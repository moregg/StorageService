class Video  < ActiveRecord::Base
  attr_accessible :width, :height, :description
  attr_accessible :transcoded, :isvalid

  def Video.make_temp_file_name(video_id)
    date = Date.today
    video_path = Rails.root.to_s + "/public/videos/" +  date.year.to_s + "_" + date.month.to_s + "_" + date.day.to_s
    if !FileTest.exists?(video_path)
      FileUtils.mkdir_p(video_path)
    end

    video_file_name = video_path  + "/" + video_id.to_s + ".mp4"
    video_file_name_l = video_file_name + "_l.jpg"
    video_file_name_m = video_file_name + "_m.jpg"
    video_file_name_s = video_file_name + "_s.jpg"

    return video_file_name, video_file_name_l, video_file_name_m, video_file_name_s
  end

  def generate_thumb
    (video_file_name,file_name_l,file_name_m,file_name_s) = Video.make_temp_file_name(self.id)

    thumb_large_str = "ffmpeg -y -i " + video_file_name + " -vframes 1 -ss 1  #{file_name_l}"
    system thumb_large_str
    #File::put_to_fs(File.open("#{TEMP_PATH}/#{self.dest_filename}_l.jpg", "r"), "#{self.partitioned_filename}_l.jpg", MOGILEFS_CLASS_VIDEOS)

    thumb_middle_str = "ffmpeg -y -i " + video_file_name + " -vframes 1 -ss 1 #{file_name_m}"
    system thumb_middle_str
    #File::put_to_fs(File.open("#{TEMP_PATH}/#{self.dest_filename}_m.jpg", "r"), "#{self.partitioned_filename}_m.jpg", MOGILEFS_CLASS_VIDEOS)

    thumb_small_str = "ffmpeg -y -i " + video_file_name + " -vframes 1 -ss 1 #{file_name_s}"
    system thumb_small_str
    #File::put_to_fs(File.open("#{TEMP_PATH}/#{self.dest_filename}_s.jpg", "r"), "#{self.partitioned_filename}_s.jpg", MOGILEFS_CLASS_VIDEOS)

    self.transcoded = 1
    self.isvalid = 1
    self.save
  end

  def get_size
   # file = File::get_from_fs(self.orig_filename.to_s, MOGILEFS_CLASS_UPLOAD_VIDEOS)
    (video_file_name,file_name_l,file_name_m,file_name_s) = Video.make_temp_file_name(self.id)
    command = "ffmpeg -i " + video_file_name + " 2>&1"
    output = `#{command}`
    video_stream = /\n\s*Stream.*Video:.*\n/.match(output)[0].strip
    match = /Stream\s*(.*?)[,|:|\(|\[].*?\s*Video:\s*(.*?),\s*(.*?),\s*(\d*)x(\d*)/.match(video_stream)
    self.width = match[4].to_i
    self.height = match[5].to_i
    self.save
  end

  def playable?
    transcoded == 1 && isvalid == 1
  end

  def write_to_mogile_fs
    (video_file_name,file_name_l,file_name_m,file_name_s) = Video.make_temp_file_name(self.id)
    MogileFsUtil.put_to_fs(video_file_name, "/" +self.id.to_s, MOGILEFS_CLASS_VIDEOS)
    MogileFsUtil.put_to_fs(file_name_l, "/" + self.id.to_s + "_l", MOGILEFS_CLASS_VIDEOS)
    MogileFsUtil.put_to_fs(file_name_m, "/" + self.id.to_s + "_m", MOGILEFS_CLASS_VIDEOS)
    MogileFsUtil.put_to_fs(file_name_s, "/" + self.id.to_s + "_s", MOGILEFS_CLASS_VIDEOS)
  end

  def partition_file_name
    if partition.blank?
      return dest_filename
    else
      return partition + "/" + dest_filename
    end
  end

  def query_to_json()
    result = {}
    result.merge!({:id => self.id, :description => self.description, :url => VIDEOS_PATH_WEB + '/' + self.partition_file_name + '.mp4'})

    if self.playable?
      result.merge!({
                        :width => self.width,
                        :height => self.height,
                        :url_l => VIDEOS_PATH_WEB + '/' + self.partition_file_name + '_l.jpg',
                        :url_m => VIDEOS_PATH_WEB + '/' + self.partition_file_name + '_m.jpg',
                        :url_s => VIDEOS_PATH_WEB + '/' + self.partition_file_name + '_s.jpg'})

    else
      result.merge!({
                        :width => 640,
                        :height => 640,
                        :url_l => VIDEOS_PATH_WEB + '/video_processing.png',
                        :url_m => VIDEOS_PATH_WEB + '/video_processing.png',
                        :url_s => VIDEOS_PATH_WEB + '/video_processing.png'})
    end


    return result
  end

  def Video.cache_key(id)
    "video_" + id.to_s
  end

  def cache_key
    "video_" + self.id.to_s
  end

  def Video.query_multi(ids)
    cache_ids = ids.collect{|id| Video.cache_key(id)}
    result = Rails.cache.read_multi(*cache_ids)

    remaining_ids = []
    ids.each do |id|
      remaining_ids << id  if result[Video.cache_key(id)] == nil
    end

    if remaining_ids.size() > 0
      db_videos = Video.where(id: remaining_ids)
      db_videos.each do |video|
        video_json = video.query_to_json
        result[Video.cache_key(video.id)] = video_json
        Rails.cache.write Video.cache_key(video.id),video_json
      end
    end

    return result
  end
end
