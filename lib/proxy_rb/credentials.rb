require 'shellwords'

module ProxyRb
  class Credentials
    protected

    attr_reader :password

    public

    attr_reader :user_name

    def initialize(user_name, password)
      @user_name = user_name
      @password  = password
    end

    def to_login
      Shellwords.escape(format('%s:%s', user_name, password))
    end
  end
end
