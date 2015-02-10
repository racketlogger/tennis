require "tennis/version"

class Tennis
  def initialize(scores)
    @scores = scores != 'default-1' && scores != 'default-2' ? scores.split(/[-,,]/).map(&:to_i) : scores
    @result = (1 if scores == 'default-1') || (2 if scores == 'default-2') || :default
    validate_score if @result == :default
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

  # returns who won the match
  # :incomplete_match (bad input/incomplete match)
  # :error (bad input for sure)
  # 1 (player-1 won)
  # 2 (player-2 won)
  def winner
    return @result unless @result == :default
    @result = (@scores.length == 4) ? two_sets : three_sets
  end

  # returns an array of points
  # returns (points_player_1 , points_player_2)
  # returns (0,0) for bad input
  def points
    @result = winner
    (return [0, 0]) if @result == :error
    (complete_match_points if @result == 1 || @result == 2) || incomplete_match_points
  end

  private

  # helper method: to check score validation
  def validate_score
    # check blank input ''
    validation_1 = @scores.any? { |score| score.nil? }
    # to check if score for only 1 set has been input
    validation_2 = @scores.length == 2
    # to check if any input > 7
    validation_3 = @scores.any? { |score| score > 7 }
    # to check if one of the input is 7 and the other is not 6
    # bad tie break input
    validation_4 = false
    @scores.each_slice(2).each {|r| validation_4 = true if r.any? {|score| score == 7} && !r.any? {|score| score == 6} }
    @result = :error if validation_1 || validation_2 || validation_3 || validation_4
    # if set score is not complete eg: 4-6,7-6,4-1
    @scores.each_slice(2).each {|r| @result = :incomplete_match if r[0] < 6 && r[1] < 6 } unless @result == :error
  end

  # helper method: called by RESULT method for valid matches with 2 sets
  def two_sets
    set_results = []
    (0...@scores.length).step(2).each do |i|
      # tie breaker (assuming a 7 point tie breaker) or a 7-5 scores
      if @scores[i] == 7 || @scores[i+1] == 7
        set_results << (@scores[i] == 7 ? 1 : 2)
        # regular set victory - 6 games with a margin of 2
      else
        return :incomplete_match if ( @scores[i] - @scores[i + 1] ).abs < 2
        set_results << (@scores[i] == 6 ? 1 : 2)
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
        set_results << (@scores[i] == 7 ? 1 : 2)
        # regular set victory - 6 games with a margin of 2
      else
        return :incomplete_match if (@scores[i] - @scores[i + 1]).abs < 2
        set_results << (@scores[i] == 6 ? 1 : 2)
      end
    end
    # checks if the result has been decided in the first 2 sets
    # but the 3rd set is also present in the input
    return :error if set_results[0] == set_results[1]
    set_results.count(1) == 2 ? 1 : 2
  end

  # helper method: called by POINTS for complete matches
  def complete_match_points
    points = [0, 0]
    @result = winner
    points[@result - 1] = (@scores.length == 6) ? 12 : 14
    runner_up = (@result == 1) ? 2 : 1
    runner_up_points = player_points(runner_up)
    points[runner_up - 1] = runner_up_points < 8 ? runner_up_points : 8
    points
  end

  # helper method: called by POINTS for incomplete matches
  def incomplete_match_points
    points = [0, 0]
    player_1_points = player_points(1)
    player_2_points = player_points(2)
    points[0] = player_1_points < 10 ? player_1_points : 10
    points[1] = player_2_points < 10 ? player_2_points : 10
    points
  end

  # helper method: returns the POINTS of a player given the player number
  def player_points(player)
    player_scores = []
    @scores.each_with_index { |score, index| (player_scores << score; player +=2) if index == (player - 1) }
    player_scores = player_scores.sort! { |x, y| y <=> x }
    player_scores[0] + player_scores[1]
  end
end
