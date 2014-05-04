require 'ruby-redtail/contact'

module RubyRedtail
  class User
    class Contacts

      CONTACT_SEARCH_FIELDS = ['LastUpdate','Name','RecAdd','PhoneNumber','TagGroup','FirstName','LastName','FamilyName','FamilyHead','ClientStatus','ContactType','ClientSource','City','State','Zip','Employer','TaxId']
      CONTACT_SEARCH_OPERANDS = ['Equals','GreaterThan','LessThan','NotEqualTo','Like','BeginsWith','IsEmpty']

      def initialize(api_hash, config)
        @api_hash = api_hash
        @config = config
      end

      # Contact Search by Name Fetch
      # returns a paged list of Contacts, associated with the search value. 
      # The searched value is based on a contact's or contacts' name.
      # http://help.redtailtechnology.com/entries/21937828-contacts-search-contacts-search#Get
      def search_by_name (value, page = 1)
        build_contacts_array RubyRedtail::Query.new(@api_hash, @config).get("contacts/search?value=#{value}&page=#{page}")["Contacts"]
      end

      # http://help.redtailtechnology.com/entries/21937828-contacts-search-contacts-search#LGet
      def search_by_letter(value, page = 1)
        build_contacts_array RubyRedtail::Query.new(@api_hash, @config).get("contacts/search/beginswith?value=#{value}&page=#{page}")["Contacts"]
      end

      # TODO: Test this properly
      # Search Contact by Custom Query
      def search (query, page = 1)
        body = Array.new(query.length) { {} }
        query.each_with_index do |expr, i|
          if expr[0] == 'TaxId'
            body[i]["Field"] = 73
          else
            body[i]["Field"] = CONTACT_SEARCH_FIELDS.index expr[0]
          end
          body[i]["Operand"] = CONTACT_SEARCH_OPERANDS.index expr[1]
          body[i]["Value"] = expr[2]
        end
        result = RubyRedtail::Query.new(@api_hash, @config).post("contacts/search?page=#{page}", body)
        build_contacts_array( result['Contacts'] )
      end

      def get_individuals(page = 1)
        result = RubyRedtail::Query.new(@api_hash, @config).get("contacts?page#{page}&type=I")
        build_contacts_array( result['Detail'] )
      end

      protected
      
      def build_contact(raw_contact)
        RubyRedtail::Contact.new(raw_contact, @api_hash, @config)
      end

      def build_contacts_array(raw_contacts)
        if raw_contacts && raw_contacts.count > 0
          return raw_contacts.collect { |contact| build_contact(contact) }
        end
        []
      end

    end
  end
end