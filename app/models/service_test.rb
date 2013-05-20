# coding: utf-8
class ServiceTest
  class << self
    def photo_add_1
      begin
        #response = RestClient.post "42.121.111.102/photos/add", :photo => File.new('3.jpg', 'rb'), :description => "hello world", :filter_info => "Activity/阿芙"
        response = RestClient.post "192.168.10.236:3000/photos/add", :photo => File.new('3.jpg', 'rb'), :description => "hello world", :filter_info => "Activity/阿芙"
        #response = RestClient.post "upload-test.vida.fm:15097/photos/add", :photo => File.new('1.png', 'rb'), :description => "hello world"
        #response = RestClient.post "localhost:3000/photos/add", :photo => File.new('1.png', 'rb'), :description => "hello world"
        puts response
      rescue Exception => e
        puts "======" + e.message
        puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      end
    end


    def photo_add_2
      begin
        response = RestClient.post "42.121.111.102/photos/add", :photo => File.new('1.png', 'rb')
        # response = RestClient.post "upload-test.vida.fm:15097/photos/add", :photo => File.new('1.png', 'rb'), :description => "hello world"
        #response = RestClient.post "localhost:3000/photos/add", :photo => File.new('1.png', 'rb')
        puts response
      rescue Exception => e
        puts "======" + e.message
        puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      end
    end

    def photo_query
      begin
        response = RestClient.post "192.168.10.236:3000/photos/query", :ids => [1, 2,7231, 7235, 7239,7241, 7257]
        #response = RestClient.post "42.121.111.102/photos/query", :ids => [5403, 100]
        # response = RestClient.post "upload-test.vida.fm:15097/photos/add", :photo => File.new('1.png', 'rb'), :description => "hello world"
        #response = RestClient.post "localhost:3000/photos/add", :photo => File.new('1.png', 'rb')
        puts response
      rescue Exception => e
        puts "======" + e.message
        puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      end
    end

    def video_add_1
      begin
        #response = RestClient.post "42.121.111.102/videos/add", :video => File.new('1.mp4', 'rb'), :description => "video xxx"
        response = RestClient.post "192.168.10.236:3000/videos/add", :video => File.new('1.mp4', 'rb'), :description => "video xxx"
        #response = RestClient.post "upload-test.vida.fm:15097/photos/add", :photo => File.new('1.png', 'rb'), :description => "hello world"
        #response = RestClient.post "localhost:3000/photos/add", :photo => File.new('1.png', 'rb'), :description => "hello world"
        puts response
      rescue Exception => e
        puts "======" + e.message
        puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      end
    end


    def video_query
      begin
        response = RestClient.post "192.168.10.236:3000/videos/query", :ids => [3, 4, 1000]
        # response = RestClient.post "upload-test.vida.fm:15097/photos/add", :photo => File.new('1.png', 'rb'), :description => "hello world"
        #response = RestClient.post "localhost:3000/photos/add", :photo => File.new('1.png', 'rb')
        puts response
      rescue Exception => e
        puts "======" + e.message
        puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      end
    end

    def audio_add_1
      begin
        #response = RestClient.post "42.121.111.102/audios/add", :audio => File.new('1.png', 'rb'), :audio_duration => 20
        response = RestClient.post "192.168.10.236:3000/audios/add", :audio => File.new('1.png', 'rb'), :audio_duration => 20
        #response = RestClient.post "upload-test.vida.fm:15097/photos/add", :photo => File.new('1.png', 'rb'), :description => "hello world"
        #response = RestClient.post "localhost:3000/photos/add", :photo => File.new('1.png', 'rb'), :description => "hello world"
        puts response
      rescue Exception => e
        puts "======" + e.message
        puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      end
    end

    def audio_query
      begin
        response = RestClient.post "192.168.10.236:3000/audios/query", :ids => [2, 3000]
        # response = RestClient.post "upload-test.vida.fm:15097/photos/add", :photo => File.new('1.png', 'rb'), :description => "hello world"
        #response = RestClient.post "localhost:3000/photos/add", :photo => File.new('1.png', 'rb')
        puts response
      rescue Exception => e
        puts "======" + e.message
        puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      end
    end

    def memcached_test_set
     h = {:user => "sbc", :password => "xxx"}
     p = Photo.new
     begin
      Rails.cache.write 123, h
      Rails.cache.write 234, p
      Rails.cache.write 345, nil
     rescue Exception => e
      puts e.message
     end
    end
    
    def memcached_test_get
       v = Rails.cache.read(123)
       puts v.class
       puts v
      
       p = Rails.cache.fetch(234)
       puts p.class
       puts p
   
       n = Rails.cache.fetch(345)
       puts n.class
       puts n
    end
  end
end
