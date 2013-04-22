class PhotosController < ApplicationController
  def add
    begin
      photo = params[:photo]
      filter_info = params[:filter_info]
      Photo.set_call_back(params[:callback_host])

      p = Photo.new(:description => params[:description])
      p.save
      p.filename = p.id.to_s
      p.save

      (photo_file_name, photo_file_name_l,photo_file_name_m,photo_file_name_s) = Photo.make_temp_file_name(p.id)
      File.open(photo_file_name, "wb+") do |f|
        f.write(photo.read)
      end

      Resque.enqueue(PhotoProcesserJob, p.id, filter_info)

      @success = true
      @photo_id = p.id
    rescue Exception => e
      @success = false
      @error_msg = e.message
    end
  end

  def query
    photo_ids = params[:ids]
    @photos = {}
    photo_ids.each do |photo_id|
      @photos[photo_id.to_s] = Photo.query(photo_id)
    end
  end


  def test_resque
    id = params[:id]
    Resque.enqueue(PhotoProcesserJob, id)

    render :text => "success"
  end
end
