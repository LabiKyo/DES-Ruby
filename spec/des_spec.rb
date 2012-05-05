# encoding: UTF-8
require "des"

describe String do
  context "when calling #is_hex" do
    it "return true if it's hex" do
      '3b3898371520f75e'.is_hex.should be_true
      '3B3898371520F75E'.is_hex.should be_true
    end
    it "return false if it contain not-hex characters" do
      '3b3898371520f75g'.is_hex.should be_false
      '3b3898371520f75G'.is_hex.should be_false
    end
  end
end
