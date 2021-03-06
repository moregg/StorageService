# encoding: utf-8
class Photo < ActiveRecord::Base
  attr_accessible :photoable_id, :photoable_type, :parent_id, :user_id
  attr_accessible :size, :width, :height, :content_type
  attr_accessible :filename, :thumbnail, :upload_filename, :orig_filename
  attr_accessible :validated, :isvalid, :del_flg
  attr_accessible :md5, :description, :partition
  # To change this template use File | Settings | File Templates.
  def Photo.set_call_back(url)
    @@call_back = url
  end

  def Photo.get_call_back
    return @@call_back
  end

  def Photo.call_back(photo_id)
    begin
      RestClient.get Photo.get_call_back + "?id=" + photo_id.to_s
    rescue Exception => e
      ProcesserLog.log "photo call back error:" + e.message
    end
  end

  def Photo.make_temp_file_name(photo_id)
    date = Date.today
    photo_path = Rails.root.to_s + "/public/photos"
    if !FileTest.exists?(photo_path)
      FileUtils.mkdir_p(photo_path)
    end

    photo_file_name = photo_path + "/" + photo_id.to_s
    photo_file_name_l = photo_file_name + "_l"
    photo_file_name_m = photo_file_name + "_m"
    photo_file_name_s = photo_file_name + "_s"

    return photo_file_name, photo_file_name_l, photo_file_name_m, photo_file_name_s
  end

  def Photo.is_afu?(filter_info)
    filter_info.force_encoding('utf-8') == "Activity/阿芙" rescue false
  end

  def Photo.is_pm25?(filter_info)
    filter_info.force_encoding('utf-8') == "Activity/PM2.5" rescue false
  end

  def Photo.generate_thunail(photo_id)
    (photo_file_name,photo_file_name_l,photo_file_name_m,photo_file_name_s) = Photo.make_temp_file_name(photo_id)

    `convert -resize 640x640 #{photo_file_name} #{photo_file_name_l}`
    Photo.create({:parent_id => photo_id, :width => 640, :height => 640, :thumbnail => "l", :filename => photo_id.to_s+"_l"})

    `convert -resize 640x640 #{photo_file_name} #{photo_file_name_m}`
    Photo.create({:parent_id => photo_id, :width => 640, :height => 640, :thumbnail => "m", :filename => photo_id.to_s+"_m"})

    `convert -resize 150x150 #{photo_file_name} #{photo_file_name_s}`
    Photo.create({:parent_id => photo_id, :width => 150, :height => 150, :thumbnail => "s", :filename => photo_id.to_s+"_s"})
  end

  def Photo.add_afu(photo_id)
    str = ["trd", "zrm"]
    f = str.shuffle[0]

    (photo_file_name,photo_file_name_l,photo_file_name_m,photo_file_name_s) = Photo.make_temp_file_name(photo_id)

    l = MiniMagick::Image.open(photo_file_name_l)
    l.combine_options do |c|
      c.draw "image SrcOver 0,0 310,210 'public/#{f}_l.png'"
    end
    l.write photo_file_name_l

    m = MiniMagick::Image.open(photo_file_name_m)
    m.combine_options do |c|
      c.draw "image SrcOver 0,0 310,210 'public/#{f}_l.png'"
    end
    m.write photo_file_name_m

    s = MiniMagick::Image.open(photo_file_name_s)
    s.combine_options do |c|
      c.draw "image SrcOver 0,0 80,54 'public/#{f}_s.png'"
    end
    s.write photo_file_name_s
  end

  def Photo.write_to_mogile_fs(photo_id)
    (photo_file_name,photo_file_name_l,photo_file_name_m,photo_file_name_s) = Photo.make_temp_file_name(photo_id)
    if MogileFsUtil.put_file_to_fs(photo_file_name, "/" + photo_id.to_s, MOGILEFS_CLASS_PICS)
      `rm -f #{photo_file_name}`
    end
    if MogileFsUtil.put_file_to_fs(photo_file_name_l, "/" + photo_id.to_s + "_l", MOGILEFS_CLASS_PICS)
      `rm -f #{photo_file_name_l}`
    end
    if MogileFsUtil.put_file_to_fs(photo_file_name_m, "/" + photo_id.to_s + "_m", MOGILEFS_CLASS_PICS)
      `rm -f #{photo_file_name_m}`
    end
    if MogileFsUtil.put_file_to_fs(photo_file_name_s, "/" + photo_id.to_s + "_s", MOGILEFS_CLASS_PICS)
      `rm -f #{photo_file_name_s}`
    end
  end

  def partition_file_name
    if partition.blank?
      return filename
    else
      return partition + "/" + filename
    end
  end

  def Photo.query_to_json(photo,photo_thumbnails)
    result = {}
    result.merge!({:origin => {:id => photo.id, :description => photo.description}})

    return result if photo_thumbnails == nil

    photo_thumbnails.each do |p|
      if p.thumbnail == "l"
        result.merge!({:l => {:width => p.width, :height => p.height, :url => PICS_PATH_WEB + "/" + p.partition_file_name}})
      elsif p.thumbnail == "m"
        result.merge!({:m => {:width => p.width, :height => p.height, :url => PICS_PATH_WEB + "/" + p.partition_file_name}})
      elsif p.thumbnail == "s"
        result.merge!({:s => {:width => p.width, :height => p.height, :url => PICS_PATH_WEB + "/" + p.partition_file_name}})
      end
    end

    return result
  end

  def Photo.cache_key(id)
     "photo_" + id.to_s
  end

  def cache_key
    "photo_" + self.id.to_s
  end

  #为了最大程度提高性能，1.从Cache中一次性捞出read_multi  2. 剩下的，从数据库中一次捞出，只调用2次sql查询：一次捞出全部photos, 另一次捞出全部photo_thumnails
  def Photo.query_multi(ids)
     cache_ids = ids.collect{|id| Photo.cache_key(id)}
     result = Rails.cache.read_multi(*cache_ids)

     remaining_ids = []
     ids.each do |id|
       remaining_ids << id  if result[Photo.cache_key(id)] == nil
     end

     if remaining_ids.size() > 0
       db_photos = Photo.where(id: remaining_ids)
       db_photo_thumbnails = Photo.where(parent_id: remaining_ids).group_by(&:parent_id)

       db_photos.each do |photo|
         photo_json = Photo.query_to_json(photo,db_photo_thumbnails[photo.id])
         result[Photo.cache_key(photo.id)] = photo_json
         Rails.cache.write Photo.cache_key(photo.id), photo_json
       end
     end

     return result
  end

end
