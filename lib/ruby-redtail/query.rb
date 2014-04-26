module RubyRedtail
  class Query
    def initialize(api_hash, config)
      @base_uri = config.api_uri
      @api_hash = api_hash
    end

    def get(uri)
      HTTParty.get(@base_uri + uri, :headers => {"Authorization" => @api_hash, 'Content-Type' => 'text/json'}).parsed_response
    end

    def post(uri, request_body=nil)
      HTTParty.post(@base_uri + uri, :headers => {"Authorization" => @api_hash, 'Content-Type' => 'text/json'}, :body => request_body.to_json).parsed_response
    end

    def put(uri, request_body=nil)
      HTTParty.put(@base_uri + uri, :headers => {"Authorization" => @api_hash, 'Content-Type' => 'text/json'}, :body => request_body.to_json).parsed_response
    end

    def delete(uri)
      HTTParty.post(@base_uri + uri, :headers => {"Authorization" => @api_hash, 'Content-Type' => 'text/json'}).parsed_response
    end

  end
end

