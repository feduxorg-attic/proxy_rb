# frozen_string_literal: true
# No proxy
class NoProxy
  def self.to_s
    ''
  end

  def self.nil?
    true
  end

  def self.empty?
    true
  end

  def nil?
    self.class.nil?
  end

  def empty?
    self.class.empty?
  end

  def to_s
    ''
  end
end
