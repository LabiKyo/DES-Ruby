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
