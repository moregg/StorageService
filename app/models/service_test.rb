class ServiceTest
  def ServiceTest.photo_add_1
    begin
      response = RestClient.post "42.121.111.102/photos/add", :photo => File.new('1.png', 'rb'), :description => "hello world"
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
      # response = RestClient.post "42.121.111.102/photos/add", :photo => File.new('1.png', 'rb'), :description => "hello world"
      # response = RestClient.post "upload-test.vida.fm:15097/photos/add", :photo => File.new('1.png', 'rb'), :description => "hello world"
      response = RestClient.post "localhost:3000/photos/add", :photo => File.new('1.png', 'rb')
      puts response
    rescue Exception => e
      puts "======" + e.message
      puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    end
  end
end