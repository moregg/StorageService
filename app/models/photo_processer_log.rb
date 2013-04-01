class PhotoProcesserLog
  @@logger = Log4r::Logger.new "photo_processer_log"
  @@out_putter = Log4r::RollingFileOutputter.new('photo_processer_log', :filename =>  'log/photo_processer.log', :maxtime=> 24*3600, :trunc => true)
  @@pattern_formatter = Log4r::PatternFormatter.new(:pattern => "%d %m\n")

  @@out_putter.formatter = @@pattern_formatter
  @@logger.outputters = @@out_putter

  def PhotoProcesserLog.log(msg)
    @@logger.info msg
  end
end