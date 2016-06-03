require 'minitest/autorun'
require 'minitest/pride'
require './lib/game.rb'

class GameTest < Minitest::Test
  def test_it_tracks_num_guesses_and_defaults_to_0
    game = Game.new
    assert_equal 0, game.num_guesses
  end

  def test_it_returns_a_message_when_starting_a_new_game
    game = Game.new
    assert_equal 'Good luck!', game.start_game
  end

  def test_it_stores_a_random_number_when_starting_a_new_game
    game = Game.new
    game.start_game
    possible_range = (0..100).to_a
    assert possible_range.include?(game.secret_number)
  end

  def test_it_has_a_message_for_guesses_taken
    game = Game.new
    message = "You've taken 0 guesses."
    assert_equal message, game.status
  end

  def test_it_can_pick_a_random_number_between_0_and_100
    game = Game.new
    range = (0..100).to_a
    assert range.include?(game.rand_number)
  end

  def test_it_can_compare_two_numbers_and_provide_feedback
    game = Game.new
    correct = 'Your guess is correct!'
    low = 'Your guess is too low.'
    high = 'Your guess is too high.'
    none = 'No guesses.'
    assert_equal correct, game.compare_guess(1, 1)
    assert_equal low, game.compare_guess(5, 1)
    assert_equal high, game.compare_guess(5, 6)
    assert_equal none, game.compare_guess(nil, 5)
  end
end
