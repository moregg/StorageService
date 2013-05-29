class MogileFsUtil
  def MogileFsUtil.put_to_fs(src_file_path, mg_key, mg_class, mg_domain = MOGILEFS_DOMAIN)
      begin
        filestore = MogileFS::MogileFS.new(:domain => mg_domain, :hosts => MOGILEFS_HOSTS)
        filestore.store_file(mg_key, mg_class, src_file_path)
      rescue Exception=>e
        MogileFsErrorLog.log e.message
        MogileFsErrorLog.log "the file is :" + src_file_path
        return false
      end
      return true
  end


  def MogileFsUtil.put_content_to_fs(content, mg_key, mg_class, mg_domain = MOGILEFS_DOMAIN)
      begin
        filestore = MogileFS::MogileFS.new(:domain => mg_domain, :hosts => MOGILEFS_HOSTS)
        filestore.store_content(mg_key, mg_class, content)
      rescue Exception=>e
        MogileFsErrorLog.log e.message
        MogileFsErrorLog.log "the file is :" + src_file_path
        return false
      end
      return true
  end

  def MogileFsUtil.get_from_fs(mg_key, mg_class, mg_domain = MOGILEFS_DOMAIN)
    begin
     # path = TEMP_PATH + '/' + UUIDTools::UUID.timestamp_create().to_s
      filestore = MogileFS::MogileFS.new(:domain => mg_domain, :hosts => MOGILEFS_HOSTS)
      data = filestore.get_file_data(mg_key)
      File.open("abc", 'wb') do |f|
        f.write(data)
      end
    rescue Exception=>e
      puts e.message 
    end
  end
end
