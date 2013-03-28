class Photo < ActiveRecord::Base
  attr_accessible :photoable_id, :photoable_type, :parent_id, :user_id
  attr_accessible :size, :width, :height, :content_type
  attr_accessible :filename, :thumbnail, :upload_filename, :orig_filename
  attr_accessible :validated, :isvalid, :del_flg
  attr_accessible :md5, :description, :partition
  # To change this template use File | Settings | File Templates.
end