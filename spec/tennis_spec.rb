require 'spec_helper'

describe Tennis, "#packge" do
	it 'has a version number' do
		expect(Tennis::VERSION).not_to be nil
	end
end

describe Tennis, "#scores" do
	it "finds the winner properly in two sets" do
		score = Tennis.new("6-4, 6-4")
		expect(score.winner).to eq 0
	end

	it "finds the winner properly in three sets" do
		score = Tennis.new("4-6, 6-2, 3-6")
		expect(score.winner).to eq 1
	end

	it "finds the winner properly in two sets with tie break" do
		score = Tennis.new("6-4, 7-6")
		expect(score.winner).to eq 0
	end

	it "finds the winner properly in three sets with tie break" do
		score = Tennis.new("6-4, 6-7, 7-6")
		expect(score.winner).to eq 0
	end

	it "reports incomplete match score (set 1-1)" do
		score = Tennis.new("6-4,4-6")
		expect(score.winner).to eq :incomplete_match
	end

	it "reports incomplete match score (set incomplete)" do
		score = Tennis.new("6-4,4-5")
		expect(score.winner).to eq :incomplete_match
	end

	it "checks invalid score: difference in games won < 2" do
		score = Tennis.new("6-5,4-6,7-6")
		expect(score.winner).to eq :incomplete_match
	end

	it "checks invalid score: only 1 set input" do
		score = Tennis.new("6-4")
		expect(score.winner).to eq :error
	end

	it "checks invalid score: winner decided in first 2 sets but 3rd set input" do
		score = Tennis.new("6-4,6-4,4-6")
		expect(score.winner).to eq :error
	end

	it "checks invalid score: bad input for tie break" do
		score = Tennis.new("7-0,4-6,6-2")
		expect(score.winner).to eq :error
	end

	it "checks invalid score: no score > 7" do
		score = Tennis.new("8-4,2-6,6-1")
		expect(score.winner).to eq :error
	end

	it "checks invalid score: blank score '' " do
		score = Tennis.new("")
		expect(score.winner).to eq :error
	end

	it "finds the winner properly in scores with 7-5" do
		score = Tennis.new("3-6,5-7")
		expect(score.winner).to eq 1
	end
end

describe Tennis, "#points" do
	it "returns 12 points in a three set win in a complete match" do
		score = Tennis.new("6-4, 4-6, 6-4")
		expect(score.points).to eq [12,8]
	end

	it "returns 14 points in two set win in a complete match" do
		score = Tennis.new("4-6, 4-6")
		expect(score.points).to eq [8,14]
	end

	it "returns a max of 8 points for the runners up in a complete match" do
		score = Tennis.new("4-6, 6-2, 3-6")
		expect(score.points).to eq [8,12]
	end

	it "return a max of 10 points for each player in an incomplete match" do
		score = Tennis.new("7-6,6-7")
		expect(score.points).to eq [10,10]
	end

	it "return a max of 10 points for each player in an incomplete match" do
		score = Tennis.new("7-6,4-6,4-1")
		expect(score.points).to eq [10,10]
	end

	it "return [0,0] for bad input" do
		score = Tennis.new("8-1")
		expect(score.points).to eq [0,0]
	end

	it "checks invalid score: blank score '' " do
		score = Tennis.new("")
		expect(score.points).to eq [0,0]
	end

	it "finds the points properly in scores with 7-5" do
		score = Tennis.new("3-6,5-7")
		expect(score.points).to eq [8,14]
	end
end

describe Tennis, "#as_string" do
	it "normalizes scores to a string properly formatted" do
		scores = [["6-4,4-6, 6-4", "6-4, 4-6, 6-4"], [" 4-6,     4-6 ", "4-6, 4-6"],
		 	[" 4 -6,     4- 6 ", "4-6, 4-6"], [" 0 - 6,     6    - 0,  3 -   6 ", "0-6, 6-0, 3-6"]]
		scores.each do |s|
			ts = Tennis.new(s[0])
			expect(ts.to_s).to eq s[1]
		end
	end
end

describe Tennis, "#flipped" do
	it "returns a normalized scores, but flipped" do
		scores = [["6-4, 4-6, 6-4", "4-6, 6-4, 4-6"], ["6-4, 7-6", "4-6, 6-7"]]
		scores.each do |s|
			ts = Tennis.new(s[0])
			expect(ts.flipped).to eq s[1]
		end
	end
end

describe Tennis, "#set_count" do
	it "returns the sets won by each player" do
		scores = [["6-4, 4-6, 6-4", [2,1]],["6-2,6-1", [2,0]], ["7-6,4-6,6-4", [2,1]], ["6-4", [1,0]]]
		scores.each do |s|
			ts = Tennis.new(s[0])
			expect(ts.set_count).to eq s[1]
		end
	end
end

describe Tennis, "#game_count" do
	it "returns the games won by each player" do
		scores = [["6-4, 4-6, 6-4", [16,14]],["6-2,6-1", [12,3]], ["7-6,4-6,6-4", [17,16]], ["6-4", [6,4]]]
		scores.each do |s|
			ts = Tennis.new(s[0])
			expect(ts.game_count).to eq s[1]
		end
	end
end
