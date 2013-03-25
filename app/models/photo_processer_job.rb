class PhotoProcesserJob
  # To change this template use File | Settings | File Templates.
  @queue = :photo_processer

  def self.perform(id)
    puts "phtoprocessJob......#{id}"
  end

end