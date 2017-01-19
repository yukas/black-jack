class BlackJack
  def initialize
    @player_points = 0
    @machine_points = 0
    @golden_point_player = 0
    @golden_point_machine = 0
    @continue_game = true
    @distribution = "Yes"
    
    @pack_parity = {
      "6S"  => 6, "6H"  => 6, "6C"  => 6,  "6D"  => 6,  "7S" => 7,  "7H" => 7, "7C" => 7, "7D" => 7,
      "8S"  => 8, "8H"  => 8, "8C"  => 8,  "8D"  => 8,  "9S" => 9,  "9H" => 9, "9C" => 9, "9D" => 9,
      "10S" => 10,"10H" => 10,"10C" => 10, "10D" => 10, "JS" => 2,  "JH" => 2, "JC" => 2,
      "JD"  => 2, "QS"  => 3, "QH"  => 3,  "QC"  => 3,  "QD" => 3,  "KS" => 4, "KH" => 4,
      "KC"  => 4, "KD"  => 4, "AS"  => 11, "AH"  => 11, "AC" => 11, "AD" => 11
    }
   
    @card_suit = {
      "S" => 6, "H" => 3, "C" => 5, "D" => 4
    }
  end

  def game
    perform_first_hand_of_cards
    perform_the_remaining_cards_are_dealt
    result_games
  end

  private
  
  attr_reader :card_player, :card_machine, :player_points, :machine_points, :golden_point_player, :golden_point_machine, 
                :pack_parity, :points, :continue_game, :distribution
              
  def perform_first_hand_of_cards
    distribution_card_player
    distribution_card_machine
  end

  def perform_the_remaining_cards_are_dealt
    while check_the_condition_of_the_continuation_of_the_game
      gameplay
    end

    report_on_completion_of_the_game
  end
  
  def check_the_condition_of_the_continuation_of_the_game
    continue_game == true && player_points < 21 && machine_points < 21 || machine_points < 19 && player_points < 21 && machine_points <= player_points
  end
  
  def gameplay
    if continue_game == true && player_points < 21
      get_the_answer_player
      to_continue_a_game?
    end
    
    distribution_card_machine if continue_game == true || machine_points <= player_points
  end
  
  def report_on_completion_of_the_game
    puts "\nИгра окончена! У меня #{machine_points} очк#{ending_word(machine_points)}, а у тебя #{player_points} очк#{ending_word(player_points)}.\n\n"
  end
  
  def get_the_answer_player
    puts "\nЖелаешь еще одну карту? Напиши 'Yes' или 'No'.\n\n"
    @distribution = gets.chomp
  end
  
  def to_continue_a_game?
    if distribution == "yes" || distribution == "Yes"
      distribution_card_player
    else
      @continue_game = false
    end 
  end
  
  def distribution_card_player
    @card_player = get_a_random_number    
    @player_points += pack_parity[card_player]
    
    check_golden_point(card_player)    
    remove_the_precipitated_card(card_player)
    
    puts "\nТебе выпала вот эта карта #{color_card(card_player)}, у тебя #{player_points} очк#{ending_word(player_points)}.\n"
  end

  def distribution_card_machine
    puts "\nТеперь моя раздача:\n\n"

    @card_machine = get_a_random_number
    @machine_points += pack_parity[card_machine]
    
    check_golden_point(card_machine)
    remove_the_precipitated_card(card_machine)
    
    puts "Мне выпала вот эта карта #{color_card(card_machine)}, у меня #{machine_points} очк#{ending_word(machine_points)}.\n"
  end
  
  def get_a_random_number
    pack_parity.keys[rand(pack_parity.size)]
  end
  
  def check_golden_point(card)
    if card == card_machine
      @golden_point_machine += 1 if pack_parity[card] == 11
    else
      @golden_point_player += 1 if pack_parity[card] == 11
    end
  end
  
  def remove_the_precipitated_card(card)
    @pack_parity = @pack_parity.delete_if { |key, value| key == card }
  end
  
  def color_card(card)
    color_card = card.chars
    color_card.pop
    color_card.join + @card_suit[card.chars.last].chr
  end
  
  def ending_word(points)
    if points == 21 || points == 31
      "о"
    elsif points >= 2 && points <= 4 || points >= 22 && points <= 24
      "а"
    elsif points >= 5 && points <= 20 || points >= 25 && points <= 30
      "ов"
    end
  end

  def result_games
    case
    when golden_point_player_win
      puts "У тебя 'золотое очко'. Ты победитель!"
    when golden_point_machine_win
      puts "У меня 'золотое очко'. Сегодня победа за мной!"
    when black_jack_player
      puts "Ты победитель!"
    when black_jack_machine
      puts "Сегодня победа за мной!"
    when draw
      puts "У нас с тобой ничья!"
    when bust_machine
      puts "Ты победитель!"
    when bust_player
      puts "Сегодня победа за мной!"
    when both_gleaning
      if player_points > machine_points
        puts "Ты победитель!"
      elsif player_points == machine_points
        puts "У нас с тобой ничья!"
      elsif player_points < machine_points
        puts "Сегодня победа за мной!"
      end
    end
  end

  def golden_point_machine_win
    machine_points == 22 && @golden_point_machine == 2
  end

  def golden_point_player_win
    player_points == 22 && @golden_point_player == 2
  end

  def black_jack_player
    player_points == 21 && machine_points != 21
  end

  def black_jack_machine
    player_points != 21 && machine_points == 21
  end

  def bust_player
    player_points > 21 && machine_points < 21
  end

  def bust_machine
    player_points < 21 && machine_points > 21
  end

  def draw
    player_points == 21 && machine_points == 21
  end

  def both_gleaning
    player_points < 21 && machine_points < 21
  end
end
