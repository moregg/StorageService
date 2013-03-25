class ServiceTest

    def ServiceTest.photo_add
      begin
        response = RestClient.post "42.121.111.102/photos/add", :photo => File.new('1.png', 'rb'), :description => "hello world"
        puts response
      rescue Exception=>e
        puts "======" + e.message
        puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        return
      end
    end


end