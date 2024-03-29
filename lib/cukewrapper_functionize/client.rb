# frozen_string_literal: true

module CukewrapperFunctionize
  class Client
    include HTTParty
    format :json

    attr_accessor :auth_token

    def initialize(config)
      self.class.base_uri(config.fetch('base_uri', default_config['base_uri']))
      @auth_token = get_auth_token
    end

    def get(path, options = {})
      options = default_options.merge(options)
      self.class.get path, options
    end

    def post(path, options = {})
      options = default_options.merge(options)
      self.class.post path, options
    end

    private

    def get_auth_token
      response = post '/generateToken', {
        headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
        body: auth_config,
      }

      raise "Error getting auth token: #{response.code} | #{response.body}" unless response.code == 200

      response.parsed_response[0]['access_token']
    end

    def default_config
      {
        'base_uri' => 'https://app.functionize.com/api/v4',
      }.freeze
    end

    def default_options
      {
        headers: {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'accesstoken' => @auth_token
        },
        query: {
          'response_type' => 'json'
        },
      }
    end

    def auth_config
      client_id = ENV['FUNCTIONIZE_USERNAME']
      client_secret = ENV['FUNCTIONIZE_PASSWORD']
      { 'apikey' => client_id, 'secret' => client_secret, 'response_type' => 'json' }
    end
  end
end