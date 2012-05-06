# encoding: UTF-8
require "des"

KEY_HEX = '3b3898371520f75e'
KEY_BIT = '0011101100111000100110000011011100010101001000001111011101011110'
ROUND = [
  '01000100110000000110101111011100100111011000100001111111', # ROUND[0]
  '10001001100000001101011110101001001110110001000011111111', # ROUND[1]
  '00010011000000011010111101010010011101100010000111111111', # ROUND[2]
  '01001100000001101011110101001001110110001000011111111100', # ROUND[3]
  '00110000000110101111010100010111011000100001111111110010', # ROUND[4]
  '11000000011010111101010001001101100010000111111111001001', # ROUND[5]
  '00000001101011110101000100110110001000011111111100100111', # ROUND[6]
  '00000110101111010100010011001000100001111111110010011101', # ROUND[7]
  '00011010111101010001001100000010000111111111001001110110', # ROUND[8]
  '00110101111010100010011000000100001111111110010011101100', # ROUND[9]
  '11010111101010001001100000000000111111111001001110110001', # ROUND[10]
  '01011110101000100110000000110011111111100100111011000100', # ROUND[11]
  '01111010100010011000000011011111111110010011101100010000', # ROUND[12]
  '11101010001001100000001101011111111001001110110001000011', # ROUND[13]
  '10101000100110000000110101111111100100111011000100001111', # ROUND[14]
  '10100010011000000011010111101110010011101100010000111111', # ROUND[15]
  '01000100110000000110101111011100100111011000100001111111', # ROUND[16]
]
SK = [
  '', # no such subkey
  '010111000000100001001100010101011000111101001111', # SK[1]
  '010100010010110111110000011001001001011111001100', # SK[2]
  '110101001110010010000101110110001011010011101111', # SK[3]
  '010100111000011100000110011011101101111010101001', # SK[4]
  '011010001001000010100111000110100111110101111011', # SK[5]
  '101100011000000001101110101011111101100100110000', # SK[6]
  '101000000100001010110010110000010110111101110010', # SK[7]
  '101101000001101100110100111111011000101000011100', # SK[8]
  '001000101101110101000010100100111000011001111100', # SK[9]
  '011010000110000101010111110110011011111110000100', # SK[10]
  '001001011100010100011001001110000110011010111101', # SK[11]
  '010001110000000110110011011110110111100010000111', # SK[12]
  '101111111000100010010001101001100110000110111011', # SK[13]
  '000111110010001010001010101001110011101101000111', # SK[14]
  '001110100001010010011100111101101000001111110010', # SK[15]
  '000100010111110010000001110101111110000101001110', # SK[16]
]
PLAIN_ASCII = 'abcdefgh'
PLAIN_BIT = '0110000101100010011000110110010001100101011001100110011101101000'
LR = [
  '1111111100000000011110000101010100000000111111111000000001100110', # LR[0]
  '0000000011111111100000000110011010100000101001110010001001111010', # LR[1]
]

ER = [
  '', # none
  '000000000001011111111111110000000000001100001100', # ER[1]
]

MIXIN = [
  '', # none
  '010111000001111110110011100101011000110001000011', # MIXIN[1]
]

SR = [
  '', # none
  '10110011011101001100111010011111', # SR[1]
]

FR = [
  '', # none
  '01011111101001110101101000101111', # FR[1]
]

S1 = "
14  4   13  1   2   15  11  8   3   10  6   12  5   9   0   7
0   15  7   4   14  2   13  1   10  6   12  11  9   5   3   8
4   1   14  8   13  6   2   11  15  12  9   7   3   10  5   0
15  12  8   2   4   9   1   7   5   11  3   14  10  0   6   13
"

describe String do
  context "when calling #is_hex" do
    it "return true if it's hex" do
      KEY_HEX.is_hex.should be_true
      KEY_HEX.upcase.is_hex.should be_true
    end
    it "return false if it contain not-hex characters" do
      '3b3898371520f75g'.is_hex.should be_false
      '3b3898371520f75G'.is_hex.should be_false
    end
  end
  context "when calling #left_rotate(i)" do
    it "left rotate i bits" do
      "01234".left_rotate(1).should eq "12340"
      "01234".left_rotate(2).should eq "23401"
    end
  end
end

describe Key do
  before :each do
    @key = Key.new KEY_HEX
  end

  # initialize
  it "initialize with 16 hex numbers" do
    key = Key.new KEY_HEX
    key.key.should eq KEY_BIT
  end
  it "raise an error when initialize with wrong arguments" do
    expect {
      Key.new '123'
    }.to raise_error ArgumentError
  end

  # sub-key rounds
  0.upto 16 do |round|
    it "has the right sub-key round #{round}" do
      @key.round[round].should eq ROUND[round]
    end
  end

  # sub-keys
  1.upto 16 do |round|
    it "has the right subkey #{round}" do
      @key.subkey[round].should eq SK[round]
    end
  end

  # encrypt
  context "when encrypting" do
    before :each do
      @entity_secret = @key.entity_encrypt PLAIN_BIT
    end

    0.upto 1 do |round|
      it "has the right left/right #{round}" do
        (@entity_secret[:left][round] + @entity_secret[:right][round]).should eq LR[round]
      end
    end

    it "has the right e-right 1" do
      @entity_secret[:e_right][1].should eq ER[1]
    end

    it "has the right minxin 1" do
      @entity_secret[:mixin][1].should eq MIXIN[1]
    end

    it "has the right s-right 1" do
      @entity_secret[:s_right][1].should eq SR[1]
    end

    it "has the right f-right 1" do
      @entity_secret[:f_right][1].should eq FR[1]
    end
  end

  # decrypt
  context "when decrypting" do
  end

  describe SBox do
    it "initialize with 12 x 4 table string" do
      sbox = SBox.new S1
    end
    context "when calling SBox#get" do
      it "return right bit string" do
        s1 = SBox.new S1
        s1.get('000000').should eq '1110' # S1[1][1] == 14
        s1.get('000010').should eq '0100' # S1[1][2] == 4
        s1.get('000001').should eq '0000' # S1[2][1] == 0
        s1.get('101000').should eq '1101' # S1[3][5] == 13
      end
    end
  end
end
