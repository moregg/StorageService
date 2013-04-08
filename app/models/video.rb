class Video  < ActiveRecord::Base
  attr_accessible :width, :height, :description
  attr_accessible :transcoded, :isvalid

  def Video.generate_thumb(video_id)
    dest_filename = UUIDTools::UUID.timestamp_create().to_s

    file = "public/" + v.id.to_s

    thumb_large_str = "ffmpeg -y -i " + file + " -vframes 1 -ss 1  #{TEMP_PATH}/#{self.dest_filename}_l.jpg"
    system thumb_large_str
    File::put_to_fs(File.open("#{TEMP_PATH}/#{self.dest_filename}_l.jpg", "r"), "#{self.partitioned_filename}_l.jpg", MOGILEFS_CLASS_VIDEOS)

    thumb_middle_str = "ffmpeg -y -i " + file + " -vframes 1 -ss 1 #{TEMP_PATH}/#{self.dest_filename}_m.jpg"
    system thumb_middle_str
    File::put_to_fs(File.open("#{TEMP_PATH}/#{self.dest_filename}_m.jpg", "r"), "#{self.partitioned_filename}_m.jpg", MOGILEFS_CLASS_VIDEOS)

    thumb_small_str = "ffmpeg -y -i " + file + " -vframes 1 -ss 1 #{TEMP_PATH}/#{self.dest_filename}_s.jpg"
    system thumb_small_str
    File::put_to_fs(File.open("#{TEMP_PATH}/#{self.dest_filename}_s.jpg", "r"), "#{self.partitioned_filename}_s.jpg", MOGILEFS_CLASS_VIDEOS)

    self.transcoded = 1
    self.isvalid = 1
    self.save
  end

  def get_size
    file = File::get_from_fs(self.orig_filename.to_s, MOGILEFS_CLASS_UPLOAD_VIDEOS)
    command = "ffmpeg -i " + file + " 2>&1"
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

end