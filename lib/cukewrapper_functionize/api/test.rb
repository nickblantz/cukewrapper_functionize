# frozen_string_literal: true

module CukewrapperFunctionize
  # Wraps the test trigger API
  class Test

    def initialize(client, test_id, project_id)
      @client = client
      response = @client.get("/test/#{test_id}", {
        query: { 'prid' => project_id, 'testid' => test_id }
      })

      raise "Error getting test: #{response.code} | #{response.body}" unless response.code == 200

      @test_id = test_id
      @project_id = project_id
    end

    def execute
      response = @client.get("/test/#{@test_id}/run", {
        query: { 'testid' => @test_id }
      })
      
      raise "Error executing test: #{response.code} | #{response.body}" unless response.code == 200
    end

    def self.execute_many(test_ids = [], tags = [], browsers = [])
      response = @client.post("/tests/run", {
        body: {
          'test_ids' => test_ids.join(','),
          'tags' => tags.join(','),
          'browsers' => browsers.join(','),
          'response_type' => 'json'
        }
      })

      raise "Error executing test: #{response.code} | #{parsed_response}" unless response.code == 200 && parsed_response['STATUS'] == 'SUCCESS'

      Run.new(@client, response.parsed_response['RESULTSET']['run_id'])
    end
  end
end
