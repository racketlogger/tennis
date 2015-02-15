require "tennis/version"

class Tennis
  # player 1 is the home player(0) , player 2 is the away player(1)
  # winner is either 0 or 1
  # points is an array: [points for 0 , points for 1]
  # sets_lost is an array: [sets lost by 0, sets lost by 1]
  # games_lost is an array: [games won by 0, games won by 1]

  attr_reader :winner, :points, :sets_lost, :games_lost

  def initialize(scores)
    # dfh -> default win for home player(0)
    # dfa -> default win for away player(1)
    @winner = :default
    @scores = validate_score(scores)
    @winner = match_winner if @winner == :default
    @points = match_points
    unless @scores.is_a? String
      @sets_lost = count_sets_lost
      @games_lost = count_games_lost
    end
  end

  # to_s
  # return the score in string format
  def to_s
    (0...@scores.length).step(2).map{ |i| [@scores[i], @scores[i+1]].join('-') }.join(', ')
  end

  # flip score ( P1-P2 to P2-P1)
  # returns the flipped score as a string
  def flipped
    (0...@scores.length).step(2).map{ |i| [@scores[i+1], @scores[i]].join('-') }.join(', ')
  end

  private

  # helper method: to check score validation
  def validate_score(scores_string)
    set_scores = scores_string.split(/[-,]/).map(&:to_i)
    if set_scores == [0]
      # checks bad default string value reported
      @winner = (0 if scores == 'dfh') || (1 if scores == 'dfa') || :error
      scores_string
    else
      # check blank input ''
      validation_1 = set_scores.any? { |score| score.nil? }
      # to check if score for only 1 set has been input
      validation_2 = set_scores.length == 2
      # to check if any input > 7
      validation_3 = set_scores.any? { |score| score > 7 }
      # to check if one of the input is 7 and the other is not 6
      # bad tie break input
      validation_4 = false
      set_scores.each_slice(2).each { |r| validation_4 = true if r.any? { |score| score == 7 } && !r.any? { |score| score == 6 || score == 5 } }
      @winner = :error if validation_1 || validation_2 || validation_3 || validation_4
      # if set score is not complete eg: 4-6,7-6,4-1
      set_scores.each_slice(2).each {|r| @winner = :incomplete_match if r[0] < 6 && r[1] < 6 } unless @winner == :error
      set_scores
    end
  end

  # returns who won the match
  # :incomplete_match (bad input/incomplete match)
  # :error (bad input for sure)
  # 0 (player-1 won)
  # 1 (player-2 won)
  def match_winner
    @scores.length == 4 ? two_sets : three_sets
  end

  # returns an array of points
  # returns (points_player_1 , points_player_2)
  # returns (0,0) for bad input
  def match_points
    return [0, 0] if @winner == :error
    return [@scores == 'dfh' ? 12 : 0, @scores == 'dfa' ? 12 : 0] if @scores.is_a? String
    @winner == 0 || @winner == 1 ? complete_match_points : incomplete_match_points
  end

  # returns the number of sets lost by each player
  def count_sets_lost
    sets = [0, 0]
    (0...@scores.length).step(2).each do |i|
      @scores[i] > @scores[i + 1] ? sets[1] += 1 : sets[0] += 1
    end
    sets
  end

  # returns the number of won by each player
  def count_games_lost
    games = [0, 0]
    (0...@scores.length).step(2).each do |i|
      games[0] += @scores[i + 1]
      games[1] += @scores[i]
    end
    games
  end

  # returns the number of sets won by each player
  def sets_won
    sets = [0, 0]
    (0...@scores.length).step(2).each do |i|
      @scores[0 + i] > @scores[1 + i] ? sets[0] += 1 : sets[1] += 1
    end
    sets
  end

  # returns the number of won by each player
  def games_won
    games = [0, 0]
    (0...@scores.length).step(2).each do |i|
      games[0] += @scores[0 + i]
      games[1] += @scores[1 + i]
    end
    games
  end

  # helper method: called by RESULT method for valid matches with 2 sets
  def two_sets
    set_results = []
    (0...@scores.length).step(2).each do |i|
      # tie breaker (assuming a 7 point tie breaker) or a 7-5 scores
      if @scores[i] == 7 || @scores[i + 1] == 7
        set_results << (@scores[i] == 7 ? 0 : 1)
        # regular set victory - 6 games with a margin of 2
      else
        return :incomplete_match if ( @scores[i] - @scores[i + 1] ).abs < 2
        set_results << (@scores[i] == 6 ? 0 : 1)
      end
    end
    # incomplete match e.g: 6-4,5-3
    (set_results[0] if set_results[0] == set_results[1]) || :incomplete_match
  end

  # helper method: called by RESULT method for valid matches with 3 sets
  def three_sets
    set_results = []
    (0...@scores.length).step(2).each do |i|
      # tie breaker (assuming a 7 point tie breaker) or a 7-5 score
      if @scores[i] == 7 || @scores[i + 1] == 7
        set_results << (@scores[i] == 7 ? 0 : 1)
        # regular set victory - 6 games with a margin of 2
      else
        return :incomplete_match if (@scores[i] - @scores[i + 1]).abs < 2
        set_results << (@scores[i] == 6 ? 0 : 1)
      end
    end
    # checks if the result has been decided in the first 2 sets
    # but the 3rd set is also present in the input
    return :error if set_results[0] == set_results[1]
    set_results.count(0) == 2 ? 0 : 1
  end

  # helper method: called by POINTS for complete matches
  def complete_match_points
    points = [0, 0]
    points[@winner] = (@scores.length == 6) ? 12 : 14
    runner_up = 1 - @winner
    runner_up_points = player_points(runner_up)
    points[runner_up] = runner_up_points < 8 ? runner_up_points : 8
    points
  end

  # helper method: called by POINTS for incomplete matches
  def incomplete_match_points
    points = [0, 0]
    player_1_points = player_points(0)
    player_2_points = player_points(1)
    points[0] = player_1_points < 10 ? player_1_points : 10
    points[1] = player_2_points < 10 ? player_2_points : 10
    points
  end

  # helper method: returns the POINTS of a player given the player number
  def player_points(player)
    player_scores = []
    @scores.each_with_index { |score, index| (player_scores << score; player += 2) if index == (player) }
    player_scores = player_scores.sort! { |x, y| y <=> x }
    player_scores[0] + player_scores[1]
  end
end
