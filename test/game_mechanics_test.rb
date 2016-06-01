require 'minitest/autorun'
require 'minitest/pride'
require './lib/game_mechanics'

class GameMechanicsTest < Minitest::Test
  include GameMechanics
  def test_it_can_pick_a_random_number_between_0_and_100
    range = (0..100).to_a
    assert range.include?(rand_number)
  end

  def test_it_can_compare_two_numbers
    assert compare_guess(1, 1)
    refute compare_guess(4, 10)
  end
end
