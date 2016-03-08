# frozen_string_literal: true
module ProxyRb
  # Raised if time out occured while fetch resource
  class UrlTimeoutError < StandardError; end

  # Raised when resource cannot be downloaded
  class ResourceNotDownloadableError < StandardError; end
end
