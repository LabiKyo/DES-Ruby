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

  def left_rotate bit
    l = self.length
    self[bit...l] + self[0...bit]
  end

end

class SBox
  def initialize table
    @table = table.split("\n").map do |line|
      line.split(' ').map do |number|
        '%04d' % number.to_i.to_s(2)
      end
    end.drop(1)
  end
  def get label
    row = (label[0] + label[5]).to_i(2)
    column = label[1..4].to_i(2)
    return @table[row][column]
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
".split("\n").map{|pair| pair.split(' ')[1].to_i}.drop(1)

SBOX = "
S1
14  4   13  1   2   15  11  8   3   10  6   12  5   9   0   7
0   15  7   4   14  2   13  1   10  6   12  11  9   5   3   8
4   1   14  8   13  6   2   11  15  12  9   7   3   10  5   0
15  12  8   2   4   9   1   7   5   11  3   14  10  0   6   13
S2
15  1   8   14  6   11  3   4   9   7   2   13  12  0   5   10
3   13  4   7   15  2   8   14  12  0   1   10  6   9   11  5
0   14  7   11  10  4   13  1   5   8   12  6   9   3   2   15
13  8   10  1   3   15  4   2   11  6   7   12  0   5   14  9
S3
10  0   9   14  6   3   15  5   1   13  12  7   11  4   2   8
13  7   0   9   3   4   6   10  2   8   5   14  12  11  15  1
13  6   4   9   8   15  3   0   11  1   2   12  5   10  14  7
1   10  13  0   6   9   8   7   4   15  14  3   11  5   2   12
S4
7   13  14  3   0   6   9   10  1   2   8   5   11  12  4   15
13  8   11  5   6   15  0   3   4   7   2   12  1   10  14  9
10  6   9   0   12  11  7   13  15  1   3   14  5   2   8   4
3   15  0   6   10  1   13  8   9   4   5   11  12  7   2   14
S5
2   12  4   1   7   10  11  6   8   5   3   15  13  0   14  9
14  11  2   12  4   7   13  1   5   0   15  10  3   9   8   6
4   2   1   11  10  13  7   8   15  9   12  5   6   3   0   14
11  8   12  7   1   14  2   13  6   15  0   9   10  4   5   3
S6
12  1   10  15  9   2   6   8   0   13  3   4   14  7   5   11
10  15  4   2   7   12  9   5   6   1   13  14  0   11  3   8
9   14  15  5   2   8   12  3   7   0   4   10  1   13  11  6
4   3   2   12  9   5   15  10  11  14  1   7   6   0   8   13
S7
4   11  2   14  15  0   8   13  3   12  9   7   5   10  6   1
13  0   11  7   4   9   1   10  14  3   5   12  2   15  8   6
1   4   11  13  12  3   7   14  10  15  6   8   0   5   9   2
6   11  13  8   1   4   10  7   9   5   0   15  14  2   3   12
S8
13  2   8   4   6   15  11  1   10  9   3   14  5   0   12  7
1   15  13  8   10  3   7   4   12  5   6   11  0   14  9   2
7   11  4   1   9   12  14  2   0   6   10  13  15  3   5   8
2   1   14  7   4   10  8   13  15  12  9   0   3   5   6   11
".split(/S\d/).drop(1).map{|table| SBox.new table}

IP = "
58  50  42  34  26  18  10  2
60  52  44  36  28  20  12  4
62  54  46  38  30  22  14  6
64  56  48  40  32  24  16  8
57  49  41  33  25  17  9   1
59  51  43  35  27  19  11  3
61  53  45  37  29  21  13  5
63  55  47  39  31  23  15  7
".table_to_a

E = "
32  1   2   3   4   5
4   5   6   7   8   9
8   9   10  11  12  13
12  13  14  15  16  17
16  17  18  19  20  21
20  21  22  23  24  25
24  25  26  27  28  29
28  29  30  31  32  1
".table_to_a

FP = "
40  8   48  16  56  24  64  32
39  7   47  15  55  23  63  31
38  6   46  14  54  22  62  30
37  5   45  13  53  21  61  29
36  4   44  12  52  20  60  28
35  3   43  11  51  19  59  27
34  2   42  10  50  18  58  26
33  1   41  9   49  17  57  25
".table_to_a

P = "
16  7   20  21
29  12  28  17
1   15  23  26
5   18  31  10
2   8   24  14
32  27  3   9
19  13  30  6
22  11  4   25
".table_to_a

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
    @subkey = []
    @round[0] = Array.new(56) {|i| @key[PC1[i]]}.join
    1.upto 16 do |round|
      rotation = ROTATION[round-1]
      left = @round[round-1][0...28].left_rotate(rotation)
      right = @round[round-1][28..-1].left_rotate(rotation)
      @round[round] = left + right
      @subkey[round] = Array.new(48) {|j| @round[round][PC2[j]]}.join
    end
  end

  def entity_encrypt plain_bits
    left = []
    right = []
    e_right = ['']
    mixin = ['']
    s_right = ['']
    f_right = ['']

    round0 = Array.new(64) {|i| plain_bits[IP[i]]}.join
    left[0] = round0[0...32]
    right[0] = round0[32..-1]

    1.upto 16 do |round|
      left[round] = right[round - 1]
      e_right[round] = Array.new(48) {|i| right[round - 1][E[i]]}.join
      mixin[round] = '%048d' % (e_right[round].to_i(2) ^ @subkey[round].to_i(2)).to_s(2)
      s_right[round] = mixin[round].scan(/.{6}/).map.with_index {|label, box| SBOX[box].get label}.join
      f_right[round] = Array.new(32) {|i| s_right[round][P[i]]}.join
      right[round] = '%032d' % (left[round - 1].to_i(2) ^ f_right[round].to_i(2)).to_s(2)
    end

    result = {
      :left => left,
      :right => right,
      :e_right => e_right,
      :mixin => mixin,
      :s_right => s_right,
      :f_right => f_right,
    }
    return result
  end

end
