class PhotosController < ApplicationController
    def add
      begin
        photo = params[:photo]
        p = Photo.new(:description => params[:description])

        File.open("public/" + params[:photo].original_filename, "wb+") do |f|
          f.write(params[:photo].read)
        end

        render :text => p.to_json
      rescue Exception => e
        render :text => false
      end
    end

    def test_resque
      resque = Resque.new
      resque << PhotoProcesserJob.new
    end
end
