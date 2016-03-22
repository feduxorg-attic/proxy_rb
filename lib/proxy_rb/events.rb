# frozen_string_literal: true
# ProxyRb
module ProxyRb
  # Events
  module Events
    # Basic event
    #
    # This is not meant for direct use - BasicEvent.new - by users. It is inherited by normal events
    #
    # @private
    class BasicEvent
      attr_reader :entity

      def initialize(entity)
        @entity = entity
      end
    end

    # Proxy was set
    class ProxySet < BasicEvent; end

    # User was set
    class ProxyUserSet < BasicEvent; end

    # User was set
    class ResourceUserSet < BasicEvent; end

    # User was set
    class ResourceSet < BasicEvent; end

    # The configuration was changed
    class ChangedConfiguration < BasicEvent; end

    # Before the resource was fetched
    class BeforeResourceFetched < BasicEvent; end

    # After the resource was fetched
    class AfterResourceFetched < BasicEvent; end
  end
end
