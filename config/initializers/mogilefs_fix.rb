=begin
class File
  class << self
    def put_to_fs(src, mg_key, mg_class, mg_domain = MOGILEFS_DOMAIN)
      if src.respond_to?(:read) #file
        begin
          filestore = MogileFS::MogileFS.new(:domain => mg_domain, :hosts => MOGILEFS_HOSTS)
          filestore.store_file(mg_key, mg_class, src.path)
        rescue
          folder_position = mg_key.rindex("/")
          if !folder_position.nil?
            path = "#{ROOT_PATH}/#{mg_class}" + "/" + mg_key[0..folder_position]
            FileUtils.mkdir_p path unless File.exists?(path)
          end

          File.open("#{ROOT_PATH}/#{mg_class}/#{mg_key}", 'wb') do |f|
            while buff = src.read(4096)
              f.write(buff)
            end
          end
        end
      else  # trunk
        begin
          filestore = MogileFS::MogileFS.new(:domain => mg_domain, :hosts => MOGILEFS_HOSTS)
          filestore.store_content("/" + mg_key, mg_class, src)
        rescue
          folder_position = mg_key.rindex("/")
          if !folder_position.nil?
            path = "#{ROOT_PATH}/#{mg_class}" + "/" + mg_key[0..folder_position]
            FileUtils.mkdir_p path unless File.exists?(path)
          end
          File.open("#{ROOT_PATH}/#{mg_class}/#{mg_key}", 'wb') do |f|
            f.write(src)
          end
        end
      end
    end

    def get_from_fs(mg_key, mg_class, mg_domain = MOGILEFS_DOMAIN)
      begin
        path = TEMP_PATH + '/' + UUIDTools::UUID.timestamp_create().to_s
        filestore = MogileFS::MogileFS.new(:domain => mg_domain, :hosts => MOGILEFS_HOSTS)
        data = filestore.get_file_data("/" + mg_key)
        File.open(path, 'wb') do |f|
          f.write(data)
        end
        return path
      rescue
        return ROOT_PATH + '/' + mg_class + '/' + mg_key
      end
    end
  end

end=end
