class Office365EasyContactsUserMapping < ActiveRecord::Base

  belongs_to :easy_contact, :class_name => "EasyContact"
  belongs_to :user

  validates_presence_of :user_id, :easy_contact_id
  validates_presence_of :easy_contact_id, scope: :user_id

  scope :deleted_or_anonymized, -> {
    joins("LEFT join easy_contacts ON #{self.table_name}.easy_contact_id = easy_contacts.id")
    .where("easy_contacts.id IS NULL OR easy_contacts.firstname IN (#{I18n.available_locales.map {|e| I18n.t(:field_anonymized, locale: e) }.map {|e| "'#{e}'"}.join(",")})")
  }
end