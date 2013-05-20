class AudiosController < ApplicationController
  def add
    begin
      audio = params[:audio]

      a = Audio.new(:duration => params[:audio_duration])
      a.save
      a.filename = a.id.to_s
      a.save

      audio_file_name = Audio.make_temp_file_name(a.id)
      File.open(audio_file_name, "wb+") do |f|
        f.write(audio.read)
      end

      Resque.enqueue(AudioProcesserJob, a.id)

      @success = true
      @audio_id = a.id
    rescue Exception => e
      @success = false
      @error_msg = e.message
    end
  end

  def query
    audio_ids = params[:ids]
    audio_jsons = Audio.query_multi(audio_ids)
    render :json => audio_jsons
  end

end

