# frozen_string_literal: true
# Proxy Rb
module ProxyRb
  # Setup proxy rb
  class Setup
    private

    attr_reader :runtime

    public

    def initialize(runtime)
      @runtime = runtime
    end

    def call
      return if runtime.setup_already_done?

      events

      runtime.setup_done

      self
    end

    private

    # disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def events
      runtime.event_bus.register(
        :proxy_set,
        proc do |event|
          runtime.announcer.announce :proxy, event.entity
        end
      )

      runtime.event_bus.register(
        :proxy_user_set,
        proc do |event|
          runtime.announcer.announce :proxy_user, event.entity
        end
      )

      runtime.event_bus.register(
        :resource_set,
        proc do |event|
          runtime.announcer.announce :resource, event.entity
        end
      )

      runtime.event_bus.register(
        :resource_user_set,
        proc do |event|
          runtime.announcer.announce :resource_user, event.entity
        end
      )

      runtime.event_bus.register(
        :after_resource_fetched,
        proc do |event|
          begin
            runtime.announcer.announce :http_response_headers, event.entity.driver.response_headers
          rescue Capybara::NotSupportedByDriverError
            runtime.announcer.announce :http_response_headers, { 'Message': format('Using #response_headers with the current driver "%s" is currently not supported', event.entity.driver.class) }
          end
        end
      )
    end
    # enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize
  end
end
