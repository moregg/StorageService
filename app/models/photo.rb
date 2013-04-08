# encoding: utf-8
class Photo < ActiveRecord::Base
  attr_accessible :photoable_id, :photoable_type, :parent_id, :user_id
  attr_accessible :size, :width, :height, :content_type
  attr_accessible :filename, :thumbnail, :upload_filename, :orig_filename
  attr_accessible :validated, :isvalid, :del_flg
  attr_accessible :md5, :description, :partition
  # To change this template use File | Settings | File Templates.

  def Photo.make_temp_file_name(photo_id)
    date = Date.today
    photo_path = Rails.root.to_s + "/public/photos/" +  date.year.to_s + "_" + date.month.to_s + "_" + date.day.to_s
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
    Photo.create({:parent_id => photo_id, :width => 640, :height => 640, :thumbnail => "l", :filename => photo_file_name_l})

    `convert -resize 640x640 #{photo_file_name} #{photo_file_name_m}`
    Photo.create({:parent_id => photo_id, :width => 640, :height => 640, :thumbnail => "m", :filename => photo_file_name_m})

    `convert -resize 150x150 #{photo_file_name} #{photo_file_name_s}`
    Photo.create({:parent_id => photo_id, :width => 150, :height => 150, :thumbnail => "s", :filename => photo_file_name_s})
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
     MogileFsUtil.put_to_fs(photo_file_name, photo_file_name, MOGILEFS_CLASS_PICS)
  end

  def Photo.query_to_json(id)
    result = {}
    begin
      p = Photo.find(id)
      result.merge!({:origin => {:photo_id => id, :description => p.description}})

      Photo.where("parent_id = ? ", id).each do |p|
        if p.thumbnail == "l"
           result.merge!({:l => {:width => p.width, :height => p.height, :filename => p.filename}})
        elsif p.thumbnail == "m"
           result.merge!({:m => {:width => p.width, :height => p.height, :filename => p.filename}})
        elsif p.thumbnail == "s"
           result.merge!({:s => {:width => p.width, :height => p.height, :filename => p.filename}})
        end
      end
    rescue ActiveRecord::RecordNotFound
      return nil
    end

    return result
  end

end