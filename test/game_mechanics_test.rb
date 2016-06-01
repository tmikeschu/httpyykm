require 'minitest/autorun'
require 'minitest/pride'
require './lib/game_mechanics'

class GameMechanicsTest < Minitest::Test
  include GameMechanics
  def test_it_can_pick_a_random_number_between_0_and_100
    range = (0..100).to_a
    assert range.include?(rand_number)
  end

  def test_it_can_compare_two_numbers_and_provide_feedback
    correct = "Your guess is correct!"
    low = "Your guess is too low."
    high = "Your guess is too high."
    assert_equal correct, compare_guess(1, 1)
    assert_equal low, compare_guess(5, 1)
    assert_equal high, compare_guess(5, 6)
  end
end
