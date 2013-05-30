class AudioProcesserJob
  @queue = :storage_service_queue

  def self.perform(audio_id)
    ProcesserLog.log("begin processing audio.........#{audio_id}")

    begin
      a = Audio.find(audio_id)
      a.write_to_mogile_fs
    rescue Exception=>e
      ProcesserLog.log e.message
    end
  end
end
