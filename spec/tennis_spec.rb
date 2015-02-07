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

  it "finds the winner properly in three sets" do
    score = Tennis.new("4-6, 6-2, 3-6")
    expect(score.result).to eq 2
  end

  it "finds the winner properly in two sets with tie break" do
    score = Tennis.new("6-4, 7-6")
    expect(score.result).to eq 1
  end

  it "finds the winner properly in three sets with tie break" do
    score = Tennis.new("6-4, 6-7, 7-6")
    expect(score.result).to eq 1
  end

  it "reports incomplete match score (set 1-1)" do
    score = Tennis.new("6-4,4-6")
    expect(score.result).to eq :incomplete_match
  end

  it "reports incomplete match score (set incomplete)" do
    score = Tennis.new("6-4,4-5")
    expect(score.result).to eq :incomplete_match
  end

  it "checks invalid score: difference in games won < 2" do
    score = Tennis.new("6-5,4-6,7-6")
    expect(score.result).to eq :error
  end

  it "checks invalid score: only 1 set input" do
    score = Tennis.new("6-4")
    expect(score.result).to eq :error
  end

  it "checks invalid score: result decided in first 2 sets but 3rd set input" do
    score = Tennis.new("6-4,6-4,4-6")
    expect(score.result).to eq :error
  end

  it "checks invalid score: bad input for tie break" do
    score = Tennis.new("7-0,4-6,6-2")
    expect(score.result).to eq :error
  end

  it "checks invalid score: no score > 7" do
    score = Tennis.new("8-4,2-6,6-1")
    expect(score.result).to eq :error
  end

end

describe Tennis, "#points" do
end
