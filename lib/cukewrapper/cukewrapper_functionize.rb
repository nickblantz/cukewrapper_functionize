# frozen_string_literal: true

module Cukewrapper
  # I process data >:^)
  class FunctionizeExecutor < Executor
    priority :normal

    def run(context)
      return unless @enabled
      
      client = CukewrapperFunctionize::Client.new @config
      test = CukewrapperFunctionize::Test.new client, @project_id, @test_id
      LOGGER.debug("#{self.class.name}\##{__method__}") { 'Executing test' }
      @run = (context.empty?) ?
        test.run(@browser) :
        test.run_with_var(@browser, context['data'])
    end

    def register_hooks
      Hooks.register("#{self.class.name}:enable", :after_metatags, &enable)
      Hooks.register("#{self.class.name}:check_result", :after_scenario, &check_result)
    end

    private

    def enable
      lambda do |_context, metatags|
        @config = CONFIG['functionize'] || {}
        @metatags = metatags['fnze'] || {}
        @test_id = @metatags['tid']
        @project_id = @metatags['pid'] || @config['project']
        @browser = @metatags['browser']
        @enabled = !@metatags['tid'].nil?
        LOGGER.debug("#{self.class.name}\##{__method__}") { @enabled }
      end
    end

    def check_status
      LOGGER.debug("#{self.class.name}\##{__method__}") { 'Checking status' }
      @run.status
    end

    def check_result
      lambda do |_context, _scenario|
        return unless @enabled

        test_failed = false

        # TODO: Fix result checks
        # wait_time = 10
        # while (status = check_status) && status['Status'] != 'Completed'
        #   LOGGER.debug("#{self.class.name}\##{__method__}") { "Current status is #{status['Status']}, sleeping #{wait_time} seconds"  }
        #   sleep wait_time
        # end

        # test_failed = false
        # for result in status['tests']
        #   test_failed = true if result['status'] != 'Passed'
        # end

        raise "Failure when executing test: #{status}" if test_failed
      end
    end
  end
end
