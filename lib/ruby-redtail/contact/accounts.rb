module RubyRedtail
  class Contact
    class Accounts
      def initialize(contact_id, api_hash, config)
        @api_hash = api_hash
        @contact_id = contact_id
        @config = config
      end

      def fetch
        RubyRedtail::Query.new(@api_hash, @config).get("contacts/#{@contact_id}/accounts", @api_hash)
      end

      def create (params)
        update(@contact_id, 0, params)
      end

      def update (account_id, params)
        RubyRedtail::Query.new(@api_hash, @config).put("contacts/#{contact_id}/accounts/#{account_id}", params)
      end

      def assets (account_id)
        RubyRedtail::Query.new(@api_hash, @config).get("contacts/#{contact_id}/#{account_id}/assets")
      end
    end
  end
end