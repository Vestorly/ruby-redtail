require 'ruby-redtail/user/contacts'
require 'ruby-redtail/user/settings'
require 'ruby-redtail/authentication'
require 'ruby-redtail/sso'

module RubyRedtail
  class User
    attr_accessor :api_hash

    # http://help.redtailtechnology.com/entries/21654562-authentication-methods
    def initialize(config, type, *args)
      @config = config

      if type == "Basic"
        self.api_hash = "Basic " + Base64.strict_encode64("#{@config.api_key}:#{args[0]}:#{args[1]}")
      elsif type == "UserKey"
        self.api_hash = "Userkeyauth " + Base64.strict_encode64("#{@config.api_key}:#{args[0]}")
      elsif type == "UserToken"
        self.api_hash = "UsertokenAuth " + Base64.strict_encode64("#{@config.api_key}:#{args[0]}")
      else
        raise ArgumentError
      end
    end
    
    def self.authenticate_via_basic(username, password, config)
      yield self.new(config, 'Basic', username, password)
    end
    
    def self.authenticate_via_user_key(key, config)
      yield self.new(config, 'UserKey', key)
    end
    
    def self.authenticate_via_user_token(token, config)
      yield self.new(config, 'UserToken', token, config)
    end
    
    # UserKey Retrieval
    # http://help.redtailtechnology.com/entries/22621068
    # returns a UserKey in exchange for the Username and Password specified in the Authentication.
	  def user_key
	    authentication.user_key
	  end
    def authentication
      RubyRedtail::Authentication.new( RubyRedtail::Query.new(self.api_hash, @config).get("authentication") )
    end
	  
    # Single Sign-On
    # http://help.redtailtechnology.com/entries/22602246
    # returns a URL for Single Sign-On based on the specified endpoint.
    # TODO: pass endpoint and id parameters
    def sso_return_url
      sso.return_url
    end
	  def sso
      RubyRedtail::Sso.new( RubyRedtail::Query.new(self.api_hash, @config).get("sso", self.api_hash) )
    end

    def contacts
      RubyRedtail::User::Contacts.new( self.api_hash, @config )
    end

    def settings
      RubyRedtail::User::Settings.new( self.api_hash, @config )
    end
  end

end