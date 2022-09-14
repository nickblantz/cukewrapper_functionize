# frozen_string_literal: true

module CukewrapperFunctionize
  # Wraps the test trigger API
  class Test
    include HTTParty
    base_uri 'https://app.functionize.com/api/v4'
    format :json

    def initialize(test_id, project_id)
      query = {
        'accesstoken' => SESSION.token,
        'prid' => project_id,
        'testid' => test_id,
        'response_type' => 'json'
      }
      response = self.class.get("/test/#{test_id}", { query: query })
      parsed_response = response.parsed_response
      raise "Error getting test: #{response.code} | #{parsed_response}" unless response.code == 200

      @test_id = test_id
      @project_id = project_id
    end

    def execute
      query = {
        'accesstoken' => SESSION.token,
        'testid' => @test_id,
        'response_type' => 'json'
      }
      response = self.class.get("/test/#{@test_id}/run", { query: query })
      parsed_response = response.parsed_response
      raise "Error executing test: #{response.code} | #{parsed_response}" unless response.code == 200

      puts parsed_response
    end

    def self.execute_many(test_ids = [], tags = [], browsers = [])
      query = { 'accesstoken' => SESSION.token }
      body = {
        'test_ids' => test_ids.join(','),
        'tags' => tags.join(','),
        'browsers' => browsers.join(','),
        'response_type' => 'json'
      }
      response = self.post("/tests/run", { query: query, body: body })
      parsed_response = response.parsed_response
      raise "Error executing test: #{response.code} | #{parsed_response}" unless response.code == 200 && parsed_response['STATUS'] == 'SUCCESS'

      Run.new(parsed_response['RESULTSET']['run_id'])
    end
  end
end
