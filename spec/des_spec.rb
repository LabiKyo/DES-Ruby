# encoding: UTF-8
require "des"

KEY_HEX = '3b3898371520f75e'
KEY_BIT = '0011101100111000100110000011011100010101001000001111011101011110'
ROUND = [
  '01000100110000000110101111011100100111011000100001111111', # SK[0]
  '10001001100000001101011110101001001110110001000011111111', # SK[1]
]

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
end

describe Key do
  before :each do
    @key = Key.new KEY_HEX
  end
  it "initialize with 16 hex numbers" do
    key = Key.new KEY_HEX
    key.key.should eq KEY_BIT
  end
  it "raise an error when initialize with wrong arguments" do
    expect {
      Key.new '123'
    }.to raise_error ArgumentError
  end
  0.upto 16 do |i|
    it "has the right round #{i}" do
      @key.round[i].should eq ROUND[i]
    end
  end
end
