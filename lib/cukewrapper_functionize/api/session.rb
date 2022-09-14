# frozen_string_literal: true

# Internals for executing RapidAPI tests
module CukewrapperFunctionize
  # Wraps the test execution API
  class FunctionizeSession
    include HTTParty
    base_uri 'https://app.functionize.com/api/v4'
    format :json

    attr_reader :token

    def initialize(client_id, client_secret)
      query = { 'apiKey' => client_id, 'secret' => client_secret, 'response_type' => 'json' }
      response = self.class.get('/generateToken', { query: query })
      raise "Error authenticating: #{response.code} | #{response.body}" unless response.code == 200

      @token = response.parsed_response[0]['access_token']
    end
  end

  SESSION = FunctionizeSession.new(ENV['FZE_CLIENT_ID'], ENV['FZE_CLIENT_SECRET'])
end
