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

	it "finds the winner properly in three sets with last set beyond tie-break" do
		score = Tennis.new("6-4, 6-7, 18-16")
		expect(score.winner).to eq 0
	end

	it "finds the winner properly in three sets with last set to 7-5" do
		score = Tennis.new("6-4, 6-7, 7-5")
		expect(score.winner).to eq 0
	end

	it "finds the winner properly in three sets with last set to 8-6" do
		score = Tennis.new("6-4, 6-7, 8-6")
		expect(score.winner).to eq 0
	end

	it "report error is the last set is off by more than 2" do
		expect { Tennis.new("6-4, 6-7, 18-15") }.to raise_error(ArgumentError)
	end

	it "report error is the last set is off by more than 2" do
		expect { Tennis.new("6-4, 6-7, 8-7") }.to raise_error(ArgumentError)
	end

	it "reports incomplete match score (set 1-1)" do
		expect { Tennis.new("6-4,4-6") }.to raise_error(ArgumentError)
	end

	it "reports incomplete match score (set incomplete)" do
		expect { Tennis.new("6-4,4-5") }.to raise_error(ArgumentError)
	end

	it "checks invalid score: difference in games won < 2" do
		expect { Tennis.new("6-5,4-6,7-6") }.to raise_error(ArgumentError)
	end

	it "checks invalid score: only 1 set input" do
		expect {  Tennis.new("6-4") }.to raise_error(ArgumentError)
	end

	it "checks invalid score: winner decided in first 2 sets but 3rd set input" do
		expect {  Tennis.new("6-4,6-4,4-6") }.to raise_error(ArgumentError)
	end

	it "checks invalid score: bad input for tie break" do
		expect {  Tennis.new("7-0,4-6,6-2") }.to raise_error(ArgumentError)
	end

	it "checks invalid score: no score > 7" do
		expect {  Tennis.new("8-4,2-6,6-1") }.to raise_error(ArgumentError)
	end

	it "checks invalid score: blank score ''" do
		expect { Tennis.new("") }.to raise_error(ArgumentError)
	end

	it "finds the winner properly in scores with 7-5" do
		score = Tennis.new("3-6,5-7")
		expect(score.winner).to eq 1
	end

	it "raises exception for bad input" do
		expect { Tennis.new("8-1") }.to raise_error(ArgumentError)
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
		scores = [["6-4, 4-6, 6-4", [1,2]],["6-2,6-1", [0, 2]], ["7-6,4-6,6-4", [1, 2]], ["6-4, 6-1", [0, 2]]]
		scores.each do |s|
			ts = Tennis.new(s[0])
			expect(ts.sets_lost).to eq s[1]
		end
	end
end

describe Tennis, "#games_lost" do
	it "returns the games won by each player" do
		scores = [["6-4, 4-6, 6-4", [14,16]],["6-2,6-1", [3, 12]], ["7-6,4-6,6-4", [16, 17]], ["6-4, 7-5", [9, 13]]]
		scores.each do |s|
			ts = Tennis.new(s[0])
			expect(ts.games_lost).to eq s[1]
		end
	end
end

describe Tennis, "#defaults" do
	it "finds the winner properly in a default" do
		score = Tennis.new("p0-win-by-something")
		expect(score.winner).to eq 0
		expect(score.sets_won).to eq [2, 0]
		expect(score.games_won).to eq [12, 0]
		expect(score.to_s).to eq "Default"
	end

	it "finds the winner properly in a default" do
		score = Tennis.new("p1-win-by-something")
		expect(score.winner).to eq 1
		expect(score.sets_won).to eq [0, 2]
		expect(score.games_won).to eq [0, 12]
		expect(score.to_s).to eq "Default"
	end

	it "reports some error in a bad default" do
		expect { Tennis.new("p2-blah") }.to raise_error(ArgumentError)
	end

end
