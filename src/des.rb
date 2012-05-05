# encoding: UTF-8

# open String to add some utils methods
# 打开String类添加工具方法
class String
  # methods for dealing with hex string
  # 格式转换方法
  def is_hex
    /^[0-9a-fA-F]+$/ =~ self
  end

end

class Key

  # attributes
  attr_accessor :key

  def initialize key_string
    unless key_string.length == 16 and key_string.is_hex
      raise ArgumentError, "Should be initialized with 16 hex numbers"
    end
    @key = '%064d' % key_string.hex.to_s(2)
  end

end
