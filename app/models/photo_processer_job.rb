class PhotoProcesserJob
  # To change this template use File | Settings | File Templates.
  @queue = :photo_processer

  def self.perform(photo_id, filter_info)
    puts "phtoprocessJob......#{photo_id}"

    Photo.generate_thunail(photo_id)

    if Photo.is_afu?(filter_info)

    end


  end

end