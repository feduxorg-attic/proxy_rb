require 'shellwords'

# ProxyRb
module ProxyRb
  # Hold proxy credentials
  class Credentials
    protected

    attr_reader :password

    public

    attr_reader :user_name

    # @param [String] user_name
    #   The user name to use for authentication against proxy
    #
    # @param [String] password
    #   The password to use for authentication against proxy
    def initialize(user_name, password)
      @user_name = user_name
      @password  = password
    end

    # Convert to string
    #
    # @return [String]
    #   A formatted string <user>:<password>
    def to_s
      Shellwords.escape(format('%s:%s', user_name, password))
    end

    # Is credentials empty
    #
    # @return [TrueClass, FalseClass]
    #   Empty if any user_name or password is empty
    def empty?
      !(user_name? && password?)
    end

    private

    def user_name?
      !(user_name.nil? || user_name.empty?)
    end

    def password?
      !(password.nil? || password.empty?)
    end
  end
end
