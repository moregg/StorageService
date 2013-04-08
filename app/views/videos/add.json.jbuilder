json.success @success
if !@success
    json.error_msg  @error_msg
else
    json.video_id @video_id
end