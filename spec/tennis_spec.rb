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
		expect { Tennis.new("6-4,4-6") }.to raise_error
	end

	it "reports incomplete match score (set incomplete)" do
		expect { Tennis.new("6-4,4-5") }.to raise_error
	end

	it "checks invalid score: difference in games won < 2" do
		expect { Tennis.new("6-5,4-6,7-6") }.to raise_error
	end

	it "checks invalid score: only 1 set input" do
		expect {  Tennis.new("6-4") }.to raise_error
	end

	it "checks invalid score: winner decided in first 2 sets but 3rd set input" do
		expect {  Tennis.new("6-4,6-4,4-6") }.to raise_error
	end

	it "checks invalid score: bad input for tie break" do
		expect {  Tennis.new("7-0,4-6,6-2") }.to raise_error
	end

	it "checks invalid score: no score > 7" do
		expect {  Tennis.new("8-4,2-6,6-1") }.to raise_error
	end

	it "checks invalid score: blank score ''" do
		expect { Tennis.new("") }.to raise_error
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

describe Tennis, "#sets_lost" do
	it "returns the sets lost by each player" do
		scores = [["6-4, 4-6, 6-4", [1,2]],["6-2,6-1", [0, 2]], ["7-6,4-6,6-4", [1, 2]], ["6-4", [0,1]]]
		scores.each do |s|
			ts = Tennis.new(s[0])
			expect(ts.sets_lost).to eq s[1]
		end
	end
end

describe Tennis, "#games_lost" do
	it "returns the games won by each player" do
		scores = [["6-4, 4-6, 6-4", [14,16]],["6-2,6-1", [3, 12]], ["7-6,4-6,6-4", [16, 17]], ["6-4", [4,6]]]
		scores.each do |s|
			ts = Tennis.new(s[0])
			expect(ts.games_lost).to eq s[1]
		end
	end
end
