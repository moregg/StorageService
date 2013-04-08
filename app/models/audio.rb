class Audio < ActiveRecord::Base
  attr_accessible :duration

  def Audio.make_temp_file_name(audio_id)
    date = Date.today
    audio_path = Rails.root.to_s + "/public/audios/" +  date.year.to_s + "_" + date.month.to_s + "_" + date.day.to_s
    if !FileTest.exists?(audio_path)
      FileUtils.mkdir(audio_path)
    end

    audio_file_name = audio_path + "/" + audio_id.to_s
    return audio_file_name
  end

  def write_to_mogile_fs

  end

  def Audio.query_to_json(id)
    result = {}
    begin
      a = Audio.find(id)
      result.merge!({:audio_id => id, :duration => a.duration})
    rescue ActiveRecord::RecordNotFound
      return nil
    end

    return result
  end
end