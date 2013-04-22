class MogileFsErrorLog
  @@logger = Log4r::Logger.new "mogile_fs_error_log"
  @@out_putter = Log4r::RollingFileOutputter.new('mogile_fs_error_log', :filename =>  Rails.root.to_s + "/log/mogile_fs_error.log", :maxtime=> 24*3600, :trunc => true)
  @@pattern_formatter = Log4r::PatternFormatter.new(:pattern => "%d %m\n")

  @@out_putter.formatter = @@pattern_formatter
  @@logger.outputters = @@out_putter

  def MogileFsErrorLog.log(msg)
    @@logger.info msg
  end
end