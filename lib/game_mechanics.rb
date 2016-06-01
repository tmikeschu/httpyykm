module GameMechanics
  def rand_number
    rand(0..100)
  end

  def compare_guess(secret, guess)
    return "Your guess is correct!" if secret == guess
    secret > guess ? difference = "too low." : difference = "too high."
    "Your guess is #{difference} (Answer is #{secret}, guess was #{guess})"
  end

end
