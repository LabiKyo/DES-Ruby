# encoding: UTF-8

# open String to add some utils methods
# 打开String类添加工具方法
class String
  # methods for dealing with hex string
  # 格式转换方法
  def is_hex
    /^[0-9a-fA-F]+$/ =~ self
  end
  # methods for dealing with tables' data
  # 添加方法以处理表格数据
  def table_to_a
    self.split(" ").map{|str| str.to_i - 1}
  end

end

# constant variables
# 定义常量
# all data comes from wikipedia[https://en.wikipedia.org/wiki/DES_supplementary_material]
# 所有数据来自维基百科[https://en.wikipedia.org/wiki/DES_supplementary_material]


PC1 = "
57  49  41  33  25  17  9
1   58  50  42  34  26  18
10  2   59  51  43  35  27
19  11  3   60  52  44  36
63  55  47  39  31  23  15
7   62  54  46  38  30  22
14  6   61  53  45  37  29
21  13  5   28  20  12  4
".table_to_a

PC2 = "
14  17  11  24  1   5
3   28  15  6   21  10
23  19  12  4   26  8
16  7   27  20  13  2
41  52  31  37  47  55
30  40  51  45  33  48
44  49  39  56  34  53
46  42  50  36  29  32
".table_to_a

# convert ROTATION from table string to array, only take the second part
# 转换ROTATION，只取第二部分
ROTATION = "
1   1
2   1
3   2
4   2
5   2
6   2
7   2
8   2
9   1
10  2
11  2
12  2
13  2
14  2
15  2
16  1
".split("\n").map{|pair| pair.split(' ')[1].to_i}

class Key

  # attributes
  attr_reader :key, :round, :subkey

  # methods
  def initialize key_string
    unless key_string.length == 16 and key_string.is_hex
      raise ArgumentError, "Should be initialized with 16 hex numbers"
    end
    @key = '%064d' % key_string.hex.to_s(2)
    self.generate_subkey
  end

  def generate_subkey
    @round = []
    @round[0] = Array.new(56) {|i| @key[PC1[i]]}.join
  end

end
