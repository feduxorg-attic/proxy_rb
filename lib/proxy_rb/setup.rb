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
    end
    # enable Metrics/MethodLength
  end
end
