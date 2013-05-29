class ImagesController < ApplicationController
  def add
    image = params[:image]
    filter_info = params[:filter_info]

    key = UUIDTools::UUID.timestamp_create.to_s

    if filter_info != nil && filter_info["180X180>"] == true
      img = MiniMagick::Image.open(image)
      img.resize "180X180>"
      image = img
    end

    if MogileFsUtil.put_to_fs(image, "/" + key, MOGILEFS_CLASS_PICS)
      render :json=>{:key => key}
    else
      render :json=>{:key => nil}
    end
  end
end
