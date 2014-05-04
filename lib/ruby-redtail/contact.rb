module RubyRedtail
  class Contact
    # http://help.redtailtechnology.com/entries/21654562-authentication-methods
    def initialize(contact = {}, api_hash, config)
      @api_hash = api_hash
      @config = config
      raise ArgumentError if contact.class != Hash
      raise ArgumentError unless contact['ClientID']
      contact.each do |key, value|
        key = key.underscore
        self.class.send :attr_accessor, key
        instance_variable_set "@#{key}", value
      end
    end


    def addresses
      RubyRedtail::Contact::Addresses.new(@api_hash, @config)
    end
    
    def notes
      RubyRedtail::Contact::Notes.new(@api_hash, @config)
    end
    
    def accounts
      RubyRedtail::Contact::Accounts.new(@api_hash, @config)
    end
    
    def activities
      RubyRedtail::Contact::Activities.new(@api_hash, @config)
    end
    
    def tag_groups
      RubyRedtail::Contact::TagGroups.new(@api_hash, @config)
    end
    
    # Fetch Contact By Contact Id
    def fetch (recent = false, basic = false)
      if basic
        RubyRedtail::Query.new(@api_hash, @config).get("contacts/#{self.client_id}/basic?recent=#{recent ? 1 : 0}")
      else
        RubyRedtail::Query.new(@api_hash, @config).get("contacts/#{self.client_id}?recent=#{recent ? 1 : 0}")
      end
    end

    # Update Contact
    def update (params)
      RubyRedtail::Query.new(@api_hash, @config).put("contacts/#{self.client_id}", params)
    end
  
    # Delete Contact
    def delete
      RubyRedtail::Query.new(@api_hash, @config).post("contacts/#{self.client_id}")['Status'] == 0
    end

    # Fetch Internet Addresses
    def internet_addresses
      RubyRedtail::Query.new(@api_hash, @config).get("contacts/#{self.client_id}/internets")
    end

    # Fetch email address
    def email_address
      addresses = internet_addresses
      addresses.collect { |address| address['Address'] if address['TypeID'] == 1 }
    end

    # Update email address
    def update_email_address(email, internet_id = 0)
      params = { TypeID:1, Address:email, ClientID:self.client_id }
      RubyRedtail::Query.new(@api_hash, @config).put("contacts/#{self.client_id}/internets/#{internet_id}", params)
    end

    # Master Fetch Contact
    def master_fetch
      RubyRedtail::Query.new(@api_hash, @config).get("contacts/#{self.client_id}/master")
    end

    # Fetch Contact Details
    def details
      RubyRedtail::Query.new(@api_hash, @config).get("contacts/#{self.client_id}/details")
    end

    # Update Contact Details
    # Is this required? (Deprecated on API website). Ask Client?
    def update_details (params)
      RubyRedtail::Query.new(@api_hash, @config).put("contacts/#{self.client_id}/details", params)
    end

    # Fetch Contact Family
    def family
      RubyRedtail::Query.new(@api_hash, @config).get("contacts/#{self.client_id}/family")
    end

    # Fetch Contact Memberships
    def memberships
      RubyRedtail::Query.new(@api_hash, @config).get("contacts/#{self.client_id}/memberships")
    end

    # Fetch Contact Personal Profile
    def personal_profile
      RubyRedtail::Query.new(@api_hash, @config).get("contacts/#{self.client_id}/personalprofile")
    end

    # Update Contact Personal Profile
    def update_personal_profile (personal_profile_id, params)
      RubyRedtail::Query.new(@api_hash, @config).put("contacts/#{self.client_id}/personalprofile/#{personal_profile_id}", params)
    end

    # Fetch Contact Important Information
    def important_information
      RubyRedtail::Query.new(@api_hash, @config).get("contacts/#{self.client_id}/importantinfo")
    end

    # Update Contact Important Information
    def update_important_information (params)
      RubyRedtail::Query.new(@api_hash, @config).put("contacts/#{self.client_id}/importantinfo", params)
    end

    # Fetch Contact Departments
    def departments
      RubyRedtail::Query.new(@api_hash, @config).get("contacts/#{self.client_id}/importantinfo")
    end

    # Fetch User Defined Fields for Contact
    def user_defined_fields
      RubyRedtail::Query.new(@api_hash, @config).get("contacts/#{self.client_id}/udf")
    end

    # Update User Defined Field for Contact
    def update_user_defined_field (udf_id, params)
      RubyRedtail::Query.new(@api_hash, @config).put("contacts/#{self.client_id}/udf/#{udf_id}", params)
    end

    # Create User Defined Field for Contact
    def create_user_defined_field (params)
      update_user_defined_field(self.client_id, 0, params)
    end
  end
end