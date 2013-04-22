class ProcesserLog
  @@logger = Log4r::Logger.new "processer_log"
  @@out_putter = Log4r::RollingFileOutputter.new('processer_log', :filename =>  Rails.root.to_s + "/log/processer.log", :maxtime=> 24*3600, :trunc => true)
  @@pattern_formatter = Log4r::PatternFormatter.new(:pattern => "%d %m\n")

  @@out_putter.formatter = @@pattern_formatter
  @@logger.outputters = @@out_putter

  def ProcesserLog.log(msg)
    @@logger.info msg
  end
end