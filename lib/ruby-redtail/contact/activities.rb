module RubyRedtail
  class Activities

    def initialize(api_hash, config)
      @api_hash = api_hash
      @config = config
    end

    # Fetch Activity By User Id, Start Date and End Date
    def fetch_by_user (user_id, start_date, end_date, basic = true, page = 1)
      RubyRedtail::Query.new(@api_hash, @config).get("calendar/#{user_id}#{"/basic" if basic}?startdate=#{start_date}&enddate=#{end_date}&page=#{page}")
    end

    # Fetch Activity By Activity Id
    def fetch (activity_id)
      RubyRedtail::Query.new(@api_hash, @config).get("calendar/activities/#{activity_id}")
    end

    # Update Activity
    def update(activity_id, params)
      RubyRedtail::Query.new(@api_hash, @config).put("calendar/activities/#{activity_id}", params)
    end

    # Create new Activity
    def create(params)
      update(0, params)
    end

    # Mark Activity as Complete
    def mark_complete(activity_id)
      RubyRedtail::Query.new(@api_hash, @config).put("calendar/activities/#{activity_id}/complete")
    end

    # Fetch List of Recent Activities
    def recent(start_date, page = 1)
      RubyRedtail::Query.new(@api_hash, @config).get("calendar/activities/recent?startdate=#{start_date}&page=#{page}")
    end

    # Fetch Activities By Contact Id
    def fetch_by_contact (contact_id, start_date, end_date, basic = true, page = 1)
      RubyRedtail::Query.new(@api_hash, @config).get("contacts/#{contact_id}/activities#{"/basic" if basic}?startdate=#{start_date}&enddate=#{end_date}&page=#{page}", "GET")
    end

  end
end