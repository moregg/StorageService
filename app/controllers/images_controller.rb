class ImagesController < ApplicationController
  def add
    image = params[:image]
    filter_info = params[:filter_info]

    key = UUIDTools::UUID.timestamp_create.to_s

    if filter_info == "180X180>"
      img = MiniMagick::Image.read(image)
      img.resize "180X180>"

      image = img.to_blob
      result= MogileFsUtil.put_content_to_fs(image, "/" + key, MOGILEFS_CLASS_PICS)
    else
      result= MogileFsUtil.put_file_to_fs(image, "/" + key, MOGILEFS_CLASS_PICS)
    end

    if result 
      render :json=>{:key => key}
    else
      render :json=>{:key => nil}
    end
  end
end
