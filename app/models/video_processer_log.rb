class VideoProcesserLog
  @@logger = Log4r::Logger.new "video_processer_log"
  @@out_putter = Log4r::RollingFileOutputter.new('video_processer_log', :filename =>  'log/video_processer.log', :maxtime=> 24*3600, :trunc => true)
  @@pattern_formatter = Log4r::PatternFormatter.new(:pattern => "%d %m\n")

  @@out_putter.formatter = @@pattern_formatter
  @@logger.outputters = @@out_putter

  def VideoProcesserLog.log(msg)
    @@logger.info msg
  end
end