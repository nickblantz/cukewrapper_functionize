# frozen_string_literal: true

module Cukewrapper
  # I process data >:^)
  class FunctionizeExecutor < Executor
    priority :normal

    def run(_context)
      return unless @enabled

      CukewrapperFunctionize::Test.new @project_id, @test_id
      LOGGER.debug("#{self.class.name}\##{__method__}") { 'Executing test' }
      @run = CukewrapperFunctionize::Test.execute_many([@test_id], [], @browsers)
    end

    def register_hooks
      Hooks.register("#{self.class.name}:enable", :after_metatags, &enable)
      Hooks.register("#{self.class.name}:check_result", :after_scenario, &check_result)
    end

    private

    def enable
      lambda do |_context, metatags|
        @config = CONFIG['functionize'] || {}
        @metatags = metatags['fze'] || {}
        @test_id = @metatags['tid']
        @project_id = @metatags['pid'] || @config['project']
        @browsers = (@metatags['browsers'] || '').split(',')
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

        wait_time = 1
        while (status = check_status) && status['Status'] != 'Completed'
          LOGGER.debug("#{self.class.name}\##{__method__}") { "Sleeping #{wait_time} seconds" }
          sleep wait_time
          wait_time *= 2
        end

        test_failed = false
        for result in status['tests']
          test_failed = true if result['status'] != 'Passed'
        end

        raise "Failure when executing test: #{status}" if test_failed
      end
    endy
  end
end
