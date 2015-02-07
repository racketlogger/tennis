require 'spec_helper'

describe Tennis, "#packge" do
  it 'has a version number' do
    expect(Tennis::VERSION).not_to be nil
  end
end

describe Tennis, "#scores" do
  it "finds the winner properly in two sets" do
    score = Tennis.new("6-4, 6-4")
    expect(score.result).to eq 1
  end
end

describe Tennis, "#points" do
end
