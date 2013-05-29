class MogileFsUtil
  @@filestore = MogileFS::MogileFS.new(:domain => MOGILEFS_DOMAIN, :hosts => MOGILEFS_HOSTS)

  def MogileFsUtil.put_file_to_fs(src_file_path, mg_key, mg_class)
      begin
        @@filestore.store_file(mg_key, mg_class, src_file_path)
      rescue Exception=>e
        MogileFsErrorLog.log e.message
        MogileFsErrorLog.log "put_file_to_fs_error:" + src_file_path
        return false
      end
      return true
  end


  def MogileFsUtil.put_content_to_fs(content, mg_key, mg_class)
      begin
        @@filestore.store_content(mg_key, mg_class, content)
      rescue Exception=>e
        MogileFsErrorLog.log e.message
        MogileFsErrorLog.log "put_content_to_fs_error:" + mg_key
        return false
      end
      return true
  end

  def MogileFsUtil.get_data_from_fs(mg_key, mg_class, mg_domain = MOGILEFS_DOMAIN)
    begin
      data = @@filestore.get_file_data(mg_key)
      return data
    rescue Exception=>e
      puts e.message
      return nil
    end
  end
end
