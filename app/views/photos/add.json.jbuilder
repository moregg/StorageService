json.success @success
if !@success
    json.error_msg  @error_msg
else
    json.photo_id @photo_id
end