class PhotoProcesserJob
  # To change this template use File | Settings | File Templates.
  @queue = :photo_processer

  def self.perform(photo_id)
    puts "phtoprocessJob......#{photo_id}"
  end

end