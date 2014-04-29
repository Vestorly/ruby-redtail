require 'base64'
require 'httparty'

require 'ruby-redtail/user'
require 'ruby-redtail/exceptions'
require 'ruby-redtail/query'

require 'core_extensions/string'

module RubyRedtail
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Configuration.new
    yield config
    raise RubyRedtail::InvalidURIError if (config.api_uri =~ URI::regexp).nil?
    raise RubyRedtail::AccessKeyError if (config.api_key.empty? || config.secret_key.empty?)
    config.api_uri << '/' unless config.api_uri[-1, 1] == '/'
  end

  class Configuration
    attr_accessor :api_key
    attr_accessor :api_uri
    attr_accessor :secret_key
  end

  class Client
    def initialize(config = RubyRedtail.config)
      @config = config
      @user = nil
    end

    # authenticate('userkey')
    # authenticate('username', 'password')
    def authenticate(*args)
      return if args.count == 0

      if args.count == 1
        RubyRedtail::User.authenticate_via_user_key(args[0], @config) do |user|
          @user = user
        end
      end

      if args.count == 2
        RubyRedtail::User.authenticate_via_basic(args[0], args[1], @config) do |user|
          @user = user
        end
      end

      @user.authentication if @user
    end

    def contact(contact_id)
      return if @user.nil?

      RubyRedtail::Contact.new( { 'ContactID' => contact_id }, @user.api_hash, @config )
    end

    def user
      @user
    end
  end
end