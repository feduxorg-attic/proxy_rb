# Main
module ProxyRb
  @debug_mode = false
  @logger     = Logger.new($stderr)

  class << self
    protected

    attr_accessor :debug_mode

    public

    attr_reader :logger

    def debug_mode_enabled?
      debug_mode == true
    end

    def enable_debug_mode
      self.debug_mode = true
      %w(pry byebug).each { |l| require l }
    end

    def require_files_matching_pattern(pattern)
      root = File.expand_path('../', __FILE__)
      path = File.join(root, pattern)
      Dir.glob(path).each { |f| require_relative f }
    end
  end
end
