class PhotosController < ApplicationController
  def add
    begin
      photo = params[:photo]
      filter_info = params[:filter_info]
      p = Photo.new(:description => params[:description])
      p.save

      File.open("public/" + p.id.to_s + ".jpg", "wb+") do |f|
        f.write(params[:photo].read)
      end

      #Resque.enqueue(PhotoProcesserJob, p.id)

      @success = true
      @photo_id = p.id
    rescue Exception => e
      @success = false
      @error_msg = e.message
    end
  end


  def test_resque
    id = params[:id]
    Resque.enqueue(PhotoProcesserJob, id)

    render :text => "success"
  end
end
