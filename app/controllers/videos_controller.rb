class VideosController < ApplicationController
  def add
    begin
      video = params[:video]
      v = Video.new(:description => params[:description])
      v.save

      File.open("public/" + v.id.to_s, "wb+") do |f|
        f.write(params[:video].read)
      end

      Resque.enqueue(VideoProcesserJob,v.id)

      @success = true
      @video_id = v.id
    rescue Exception => e
      @success = false
      @error_msg = e.message
    end
  end


end
