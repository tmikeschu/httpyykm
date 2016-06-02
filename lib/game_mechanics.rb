module GameMechanics
  
  def rand_number
    rand(0..100)
  end

  def compare_guess(secret, guess)
    return "No guesses." if secret == nil || guess == nil
    return "Your guess is correct!" if secret == guess
    secret > guess ? difference = "too low." : difference = "too high."
    "Your guess is #{difference}"
  end

end
