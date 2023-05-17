# frozen_string_literal: true

module CukewrapperFunctionize
  # Wraps the test execution API
  class Run
    def initialize(client, run_id)
      @client = client
      @run_id = run_id
    end

    def status
      response = @client.get("/tests/run/#{@run_id}/status", {
        query: { 'run_id' => @run_id }
      })

      raise "Error checking testexcecution status: #{response.code} | #{response.body}" unless response.code == 200

      response.parsed_response
    end
  end
end
