require 'test_helper'

class StatsTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  test "create empty stats" do
    assert Stats.new
  end

  test "cannot save stats w/o user id" do
    bad_stats = Stats.create(:wins => 5, :games_played => 6)
    assert !bad_stats.save
  end

  test "wins cannot be greater than games played" do
    bad_wins = Stats.create(:user_id => 1, :wins => 6, :games_played => 2)
    assert bad_wins.save
  end

end
