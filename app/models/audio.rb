class Audio < ActiveRecord::Base
  attr_accessible :duration

  def Audio.make_temp_file_name(audio_id)
    date = Date.today
    audio_path = Rails.root.to_s + "/public/audios/" +  date.year.to_s + "_" + date.month.to_s + "_" + date.day.to_s
    if !FileTest.exists?(audio_path)
      FileUtils.mkdir_p(audio_path)
    end

    audio_file_name = audio_path + "/" + audio_id.to_s
    return audio_file_name
  end

  def write_to_mogile_fs
     audio_file_name = Audio.make_temp_file_name(self.id)   
     MogileFsUtil.put_to_fs(audio_file_name, "/" + self.id.to_s, MOGILEFS_CLASS_AUDIOS)
  end

  def Audio.query_to_json(id)
    result = {}
    begin
      a = Audio.find(id)
      result.merge!({:audio_id => id, :duration => a.duration, :url => a.url})
    rescue ActiveRecord::RecordNotFound
      return nil
    end

    return result
  end

  def url
    if partition.blank?
      "#{AUDIO_WEB}/#{filename}.m4a"
    else
      "#{AUDIO_WEB}/#{partition}/#{filename}.m4a"
    end
  end

  def Audio.query(id)
     cache_id = "audio_" + id.to_s
     a = Rails.cache.fetch(cache_id)
     if a == nil
       a = Audio.query_to_json(id)
       Rails.cache.write cache_id, a
     end
     return a
  end

end

