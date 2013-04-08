class Audio < ActiveRecord::Base
  attr_accessible :duration

  def Audio.make_temp_file_name(audio_id)
    audio_path = File.join(Rails.root, 'public/audios')
    if !FileTest.exists?(audio_path)
      FileUtils.mkdir(audio_path)
    end

    audio_file_name = audio_path + "/" + audio_id.to_s
    return audio_file_name
  end

  def wirte_to_mogile_fs

  end
end