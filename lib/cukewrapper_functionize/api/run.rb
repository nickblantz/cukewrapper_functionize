# frozen_string_literal: true

module CukewrapperFunctionize
  # Wraps the test execution API
  class Run
    include HTTParty
    base_uri 'https://app.functionize.com/api/v4'
    format :json

    def initialize(run_id)
      @run_id = run_id
    end

    def status
      query = {
        'accesstoken' => SESSION.token,
        'run_id' => @run_id,
        'response_type' => 'json'
      }
      response = self.class.get("/tests/run/#{@run_id}/status", { query: query })
      parsed_response = response.parsed_response
      raise "Error checking testexcecution status: #{response.code} | #{response.body}" unless response.code == 200

      return parsed_response
    end
  end
end
