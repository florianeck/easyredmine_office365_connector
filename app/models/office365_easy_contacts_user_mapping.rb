class Office365EasyContactsUserMapping < ActiveRecord::Base

  belongs_to :easy_contact, :class_name => "EasyContact"
  belongs_to :user

  validates_presence_of :user_id, :easy_contact_id
  validates_presence_of :easy_contact_id, scope: :user_id

end