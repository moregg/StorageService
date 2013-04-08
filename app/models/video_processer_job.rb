class VideoProcesserJob
  @queue = :video_processer

  def self.perform(video_id)
    VideoProcesserLog.log("begin processing video......#{video_id}")

    begin
      v = Video.find(video_id)
      v.generate_thumb
      v.get_size
      v.write_to_mogile_fs
    rescue Exception => e
      VideoProcesserLog.log(e.message)
    end
  end

end