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

    def to_s
      Shellwords.escape(format('%s:%s', user_name, password))
    end

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
