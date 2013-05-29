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
     if MogileFsUtil.put_file_to_fs(audio_file_name, "/" + self.id.to_s, MOGILEFS_CLASS_AUDIOS)
       `rm -f #{audio_file_name}`
     end
  end

  def query_to_json
    result = {:id => self.id, :duration => self.duration, :url => self.url}
  end

  def url
    if partition.blank?
      "#{AUDIO_WEB}/#{filename}.m4a"
    else
      "#{AUDIO_WEB}/#{partition}/#{filename}.m4a"
    end
  end

  def Audio.cache_key(id)
    "audio_" + id.to_s
  end

  def cache_key
    "audio_" + self.id.to_s
  end

  def Audio.query_multi(ids)
    cache_ids = ids.collect{|id| Audio.cache_key(id)}
    result = Rails.cache.read_multi(*cache_ids)

    remaining_ids = []
    ids.each do |id|
      remaining_ids << id  if result[Audio.cache_key(id)] == nil
    end

    if remaining_ids.size() > 0
      db_audios = Audio.where(id: remaining_ids)
      db_audios.each do |audio|
        audio_json = audio.query_to_json
        result[Audio.cache_key(audio.id)] = audio_json
        Rails.cache.write Audio.cache_key(audio.id),audio_json
      end
    end

    return result
  end

end

