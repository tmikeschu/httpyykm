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

  def test_it_can_compare_two_numbers_and_provide_feedback_if_correct_or_nil
    game = Game.new
    correct = 'Your guess is correct!'
    none = 'No guesses.'
    assert_equal correct, game.compare_guess(1, "1")
    assert_equal none, game.compare_guess(nil, "5")
  end

  def test_it_compares_two_numbers_and_reports_if_too_low_or_too_high
    game = Game.new
    low = 'Your guess is too low.'
    assert_equal low, game.compare_guess(4, "1")
    high = 'Your guess is too high.'
    assert_equal high, game.compare_guess(45, "90")
  end

  def test_if_guessed_num_includes_any_non_numerical_chars_special_message
    game = Game.new
    response = "Guess a number only, please."
    assert_equal response, game.compare_guess(46, "4a")
  end
end
