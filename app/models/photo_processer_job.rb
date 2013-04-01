class PhotoProcesserJob
  # To change this template use File | Settings | File Templates.
  @queue = :photo_processer

  def self.perform(photo_id)
    puts "phtoprocessJob......#{photo_id}"

    photo_file_name = "public/" + photo_id.to_s + ".jpg"
    photo_file_name_l = "public/" + photo_id.to_s + "_l.jpg"
    photo_file_name_m = "public/" + photo_id.to_s + "_m.jpg"
    photo_file_name_s = "public/" + photo_id.to_s + "_s.jpg"

    `convert -resize 640x640 #{photo_file_name} #{photo_file_name_l}`
    `convert -resize 640x640 #{photo_file_name} #{photo_file_name_m}`
    `convert -resize 150x150 #{photo_file_name} #{photo_file_name_s}`
  end

end