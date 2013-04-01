class PhotoProcesserJob
  # To change this template use File | Settings | File Templates.
  @queue = :photo_processer

  def self.perform(photo_id, filter_info)
    PhotoProcesserLog.log("begin processing photo......#{photo_id}....#{filter_info}")

    begin
      Photo.generate_thunail(photo_id)

      if Photo.is_afu?(filter_info)
        PhotoProcesserLog.log("begin processing afu...")
        Photo.add_afu(photo_id)
      end
    rescue Exception=>e
      PhotoProcesserLog.log(e.message)
    end                                                                                                                                             .

    PhotoProcesserLog.log("end processing photo..........................")
  end

end