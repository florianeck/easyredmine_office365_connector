class O365Contact

  attr_reader :easy_contact

  def initialize(easy_contact)
    @easy_contact = easy_contact
  end

  def to_json
    {
      "DisplayName" => "Pavel Bansky",
      "GivenName" => "Pavel",
      "Surname" => "Bansky",
      "Title" => null,
      "EmailAddresses" => [],
      "JobTitle" => null,
      "CompanyName" => null,
      "Department" => null,
      "OfficeLocation" => null,
      "Profession" => null,
      "BusinessHomePage" => null,
      "AssistantName" => null,
      "Manager" => null,
      "HomePhones" => [
        null,
        null
      ],
      "BusinessPhones" => [
        "+1 732 555 0102",
        null
      ],
      "MobilePhone1" => null,
      "HomeAddress" => {
        "Street" => null,
        "City" => null,
        "State" => null,
        "CountryOrRegion" => null,
        "PostalCode" => null
      },
      "BusinessAddress" => {
        "Street" => null,
        "City" => null,
        "State" => null,
        "CountryOrRegion" => null,
        "PostalCode" => null
      },
      "OtherAddress" => {
        "Street" => null,
        "City" => null,
        "State" => null,
        "CountryOrRegion" => null,
        "PostalCode" => null
      },
      "PersonalNotes" => null,
      "Children" => [],
    }
  end

  def parent_company
    if
  end

end