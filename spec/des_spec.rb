# encoding: UTF-8
require "des"

KEY_HEX = '3b3898371520f75e'
KEY_BIT = '0011101100111000100110000011011100010101001000001111011101011110'

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
  it "initialize with 16 hex numbers" do
    key = Key.new KEY_HEX
    key.key.should eq KEY_BIT
  end
  it "raise an error when initialize with wrong arguments" do
    expect { Key.new '123' }.to raise_error ArgumentError, "Should be initialized with 16 hex numbers"
  end
end
