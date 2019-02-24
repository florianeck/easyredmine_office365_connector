class O365Contact

  attr_reader :easy_contact

  def initialize(easy_contact)
    @easy_contact = easy_contact
  end

  def to_json
    {
      "DisplayName"   => easy_contact.name,
      "GivenName"     => easy_contact.person? ? easy_contact.firstname : nil,
      "Surname"       => easy_contact.person? ? easy_contact.lastname : nil,
      "Title" => nil, # => TODO: GET from custom fields
      "EmailAddresses" => [easy_contact.email],
      "JobTitle" => nil, # => TODO: GET from custom fields
      "CompanyName" => easy_contact.person? ? parent_company.try(:name) : easy_contact.name,
      #"Department" => null,
      #"OfficeLocation" => null,
      #"Profession" => null,
      #"BusinessHomePage" => null,
      #"Manager" => null,
      "BusinessPhones" => [easy_contact.custom_field_value(EasyContacts::CustomFields.telephone_id)],
      "MobilePhone1" => nil, # => TODO: GET from custom fields
      "BusinessAddress" => {
        "Street" => easy_contact.street,
        "City" => easy_contact.city,
        "State" => easy_contact.state,
        "CountryOrRegion" => nil,
        "PostalCode" => nil
      },
      "PersonalNotes" => easy_contact.projects.map(&:name).join(" / "),
    }
  end

  def parent_company_name
    if easy_contact.person? && easy_contact.parent.company?
      easy_contact.parent
    elsif easy_contact.person?
      easy_contact.custom_field_value(EasyContacts::CustomFields.organization_id)
    end
  end

end