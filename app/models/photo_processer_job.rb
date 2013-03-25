class PhotoProcesserJob
  # To change this template use File | Settings | File Templates.
  @queue = :photo_processer

  def work
    puts "phtoprocessJob......"
  end
end