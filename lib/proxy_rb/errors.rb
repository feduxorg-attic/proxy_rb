# frozen_string_literal: true
module ProxyRb
  # Raised if time out occured while fetch resource
  class UrlTimeoutError < StandardError; end

  # Raised when resource cannot be downloaded
  class ResourceNotDownloadableError < StandardError; end

  # Raised if one tries to use an unknown configuration option
  class UnknownOptionError < ArgumentError; end

  # Raised if an event name cannot be resolved
  class EventNameResolveError < StandardError; end

  # Raised if given object is not an event
  class NoEventError < StandardError; end
end
