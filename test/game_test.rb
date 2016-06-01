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
end
