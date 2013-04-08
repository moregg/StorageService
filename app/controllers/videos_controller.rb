class VideosController < ApplicationController
  def add
    begin
      video = params[:video]
      v = Video.new(:description => params[:description])
      v.save

      (video_file_name,file_name_l,file_name_m,file_name_s) = Video.make_temp_file_name(v.id)
      File.open(video_file_name, "wb+") do |f|
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
