# coding: utf-8
class ServiceTest
  def ServiceTest.photo_add_1
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

  def ServiceTest.photo_add_2
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

  def ServiceTest.photo_query
    begin
      response = RestClient.post "42.121.111.102/photos/query", :ids => [5403, 100]
      # response = RestClient.post "upload-test.vida.fm:15097/photos/add", :photo => File.new('1.png', 'rb'), :description => "hello world"
      #response = RestClient.post "localhost:3000/photos/add", :photo => File.new('1.png', 'rb')
      puts response
    rescue Exception => e
      puts "======" + e.message
      puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    end
  end

  def ServiceTest.video_add_1
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


  def ServiceTest.video_query
    begin
      response = RestClient.post "42.121.111.102/videos/query", :ids => [100, 25, 1000]
      # response = RestClient.post "upload-test.vida.fm:15097/photos/add", :photo => File.new('1.png', 'rb'), :description => "hello world"
      #response = RestClient.post "localhost:3000/photos/add", :photo => File.new('1.png', 'rb')
      puts response
    rescue Exception => e
      puts "======" + e.message
      puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    end
  end

  def ServiceTest.audio_add_1
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

  def ServiceTest.audio_query
    begin
      response = RestClient.post "42.121.111.102/audios/query", :ids => [2, 3000]
      # response = RestClient.post "upload-test.vida.fm:15097/photos/add", :photo => File.new('1.png', 'rb'), :description => "hello world"
      #response = RestClient.post "localhost:3000/photos/add", :photo => File.new('1.png', 'rb')
      puts response
    rescue Exception => e
      puts "======" + e.message
      puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    end
  end

end
