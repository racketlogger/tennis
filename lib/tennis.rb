require "tennis/version"

class Tennis
  # player 1 is the home player(0) , player 2 is the away player(1)
  # winner is either 0 or 1
  # points is an array: [points for 0 , points for 1]
  # sets_lost is an array: [sets lost by 0, sets lost by 1]
  # games_lost is an array: [games won by 0, games won by 1]

  attr_reader :winner, :points, :sets_lost, :games_lost

  def initialize(score)
    # dfh -> default win for home player(0)
    # dfa -> default win for away player(1)
    process_score(score)
  end

  # to_s
  # return the score in string format
  def to_s
    @score.map{|set| set.join('-') }.join(', ')
  end

  # flip score ( P1-P2 to P2-P1)
  # returns the flipped score as a string
  def flipped
    @score.map{|set| set.reverse.join('-') }.join(', ')
  end

  private

  def process_score(score, best_of=3)
    begin
      sets = score.split(/,/)
      # only take 2 to 5 sets
      raise "invalid number of sets" unless (2..best_of).cover? sets.length
      score_plus_winner = map_scores_winners(sets)
      @set_winners = score_plus_winner.map{ |sw| sw[1] }
      home = @set_winners.count(0)
      away = @set_winners.count(1)
      raise "nobody won" if home + away == 0
      @winner = home > away ? 0 : away > home ? 1 : raise("no winner")
      # sets won and lost
      @sets_won, @sets_lost = [[home, away], [away, home]]
      # score array
      @score = score_plus_winner.map{ |sw| sw[0] }
      @games_won = @score.transpose.map{ |games| games.inject{ |sum,x| sum + x } }
      @games_lost = @games_won.reverse
      # FIXME this is the only thing that assumes 3 sets
      raise "too many sets" if @set_winners[0] == @set_winners[1] and sets.size > 2
    rescue => e
      raise ArgumentError, "Invalid score '#{score}': #{e}"
    end
  end

  # return an array of scores and winners for each set
  def map_scores_winners(sets)
    sets.map do |set|
      set.strip!
      games = set.split(/-/).map(&:to_i)
      raise "uneven games in set '#{set}'" unless games.length == 2
      h, a = games
      sw = set_winner(h, a)
      raise "no valid winner in set '#{set}'" unless sw
      [games, sw]
    end
  end

  # determine the set winner for home and away, or else return nil
  def set_winner(h, a)
    # basic range check
    return nil if h > 7 or a > 7 or h < 0 or a < 0
    # game went to 7
    return 0 if h == 7 and [5,6].include?(a)
    return 1 if a == 7 and [5,6].include?(h)
    # there has to be one winner, to 6
    return nil unless (h == 6 and h > a + 1) or (a == 6 and a > h + 1)
    h > a ? 0 : 1
  end

end
