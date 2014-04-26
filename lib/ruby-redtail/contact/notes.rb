module RubyRedtail
  class Notes
    def initialize(api_hash, config)
      @api_hash = api_hash
      @config = config
    end

    # Fetch Notes By Contact Id
    def fetch (contact_id, page = 1)
      RubyRedtail::Query.new(@api_hash, @config).get("contacts/#{contact_id}/notes?page=#{page}")
    end

    # Update Note
    def update (contact_id, note_id, params)
      RubyRedtail::Query.new(@api_hash, @config).put("contacts/#{contact_id}/notes/#{note_id}", params)
    end

    # Create New Note
    def create (contact_id, params)
      update(contact_id, 0, params)
    end

    # Fetch Recently Added Notes
    def recent
      RubyRedtail::Query.new(@api_hash, @config).get("contacts/notes/recent")
    end
  end
end