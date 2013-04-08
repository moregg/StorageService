class VideoProcesserJob
  @queue = :video_processer

  def self.perform(video_id)
    VideoProcesserLog.log("begin processing video......#{video_id}")

    begin
      puts "xxx"
    rescue Exception => e
      VideoProcesserLog.log(e.message)
    end
  end


end