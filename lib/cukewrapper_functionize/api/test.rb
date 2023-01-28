# frozen_string_literal: true

module CukewrapperFunctionize
  # Wraps the test trigger API
  class Test

    def initialize(client, project_id, test_id)
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

    def base_context(payload)
      payload.transform_values { |value|
        case value
        when Hash, Array
          value.to_json
        when Integer, Float, TrueClass, FalseClass, String
          value
        when NilClass
          'null'
        else
          value.to_s
        end
      }
      .map { |k, v| { 'variable_name' => k, 'variable_value' => v } }
      .to_json
    end

    def run(browser)
      response = @client.get("/test/#{@test_id}/run", {
        query: {
          'browser' => browser,
          'response_type' => 'json'
        }
      })

      raise "Error executing test: #{response.code} | #{response.parsed_response}" unless response.code == 200 && response.parsed_response['STATUS'] == 'SUCCESS'
      # TODO: Fix result checks
      # time = response.parsed_response['RESULTSET'][0]['start_time']
      # result_list(time, time)
      # Run.new(@client, response.parsed_response['RESULTSET']['run_id'])
      nil
    end

    def run_with_var(browser, vars)
      response = @client.post("/test/#{@test_id}/runwithvar", {
        headers: { 'Content-Type' => 'application/x-www-form-urlencoded', 'accesstoken' => @client.auth_token },
        body: {
          'browser' => browser,
          'variableJson' => base_context(vars),
          'response_type' => 'json'
        }
      })

      raise "Error executing test: #{response.code} | #{response.parsed_response}" unless response.code == 200 && response.parsed_response['STATUS'] == 'SUCCESS'

      # TODO: Fix result checks
      # Run.new(@client, response.parsed_response['RESULTSET']['run_id'])
      nil
    end

    def execute_many(test_ids = [], tags = [], browsers = [])
      response = @client.post("/tests/run", {
        body: {
          'test_ids' => test_ids.join(','),
          'tags' => tags.join(','),
          'browsers' => browsers.join(','),
          'response_type' => 'json'
        }
      })

      raise "Error executing test: #{response.code} | #{response.parsed_response}" unless response.code == 200 && response.parsed_response['STATUS'] == 'SUCCESS'

      Run.new(@client, response.parsed_response['RESULTSET']['run_id'])
    end

    def result_list(start_time, end_time)
      while true do
        sleep 10
        response = @client.get("/test/result/list", {
          query: {
            'testid' => @test_id,
            'startdatetime' => start_time,
            'enddatetime' => end_time,
            'response_type' => 'json'
          }
        })
        Kernel.puts response.parsed_response
      end

      raise "intentional stop"

    end
  end
end
