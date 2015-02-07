require 'spec_helper'

describe Tennis, "#scores" do
  it "finds the winner properly in two sets" do
    score = Tennis.new("6-4, 6-4")
    expect(score.result).to eq 1
  end
end

describe Tennis, "#points" do
end
