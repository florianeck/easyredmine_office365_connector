class O365ContactMapper

  attr_reader :easy_contact

  def initialize(easy_contact)
    @easy_contact = easy_contact
  end

  def to_hash
    {
      "DisplayName"   => easy_contact.name,
      "GivenName"     => easy_contact.person? ? easy_contact.firstname : nil,
      "Surname"       => easy_contact.person? ? easy_contact.lastname : nil,
      "Title" => easy_contact.custom_field_value(EasyredmineOfficeConnector.title_custom_field_id),
      "EmailAddresses" => [
        (easy_contact.email.present? ? {"address" => easy_contact.email, "name" => easy_contact.name } : nil)
      ].compact,
      "JobTitle" => easy_contact.custom_field_value(EasyredmineOfficeConnector.job_title_custom_field_id),
      "CompanyName" => (easy_contact.person? ? parent_company_name : easy_contact.name),
      "Department" => easy_contact.custom_field_value(EasyredmineOfficeConnector.department_custom_field_id),
      #"OfficeLocation" => null,
      #"Profession" => null,
      "BusinessHomePage" => parent_company.try(:custom_field_value, EasyredmineOfficeConnector.website_custom_field_id),
      #"Manager" => null,
      "BusinessPhones" => [easy_contact.custom_field_value(EasyContacts::CustomFields.telephone_id)].compact,
      "MobilePhone1" => [
        easy_contact.custom_field_value(EasyredmineOfficeConnector.mobile_custom_field_id)
      ].compact,
      "BusinessAddress" => {
        "Street" => easy_contact.street.presence || parent_company.try(:street),
        "City" => easy_contact.city.presence || parent_company.try(:city),
        "State" => easy_contact.state.presence || parent_company.try(:state ),
        "CountryOrRegion" => easy_contact.custom_field_value(EasyredmineOfficeConnector.country_custom_field_id),
        "PostalCode" => easy_contact.zip.presence || parent_company.try(:zip)
      },
      "PersonalNotes" => easy_contact.projects.map(&:name).join(" / "),
    }
  end

  def parent_company_name
    if easy_contact.person? && easy_contact.parent && easy_contact.parent.company?
      easy_contact.parent.try(:name)
    elsif easy_contact.person?
      easy_contact.custom_field_value(EasyContacts::CustomFields.organization_id)
    end
  end

  def parent_company
    @_parent_company ||= if easy_contact.person? && easy_contact.parent && easy_contact.parent.company?
      easy_contact.parent
    end
  end


end