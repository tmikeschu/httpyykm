module GameMechanics
  def rand_number
    rand(0..100)
  end

  def compare_guess(secret, guess)
    secret == guess
  end

end
