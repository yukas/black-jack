# Симулятор игры в "очко". 
#Версия 1.1 
#Изменения: 1. Добавлено правило "золотое очко", 2. Реализовано исключение из колоды розданных карт, 
#           3. Реализованы верные окончания слов, 4. Переделан внешний вид программы, 
#           5. Сделан более удобный интерфейс программы, 6. Доработана логика метода gameplay.
#           7. Показывает карты с мастью.
#
# (c) Dostankius Sergeus	
	
	class BlackJack
  attr_reader :machine_points
  attr_reader :player_points
  attr_reader :golden_point_machine
  attr_reader :golden_point_player
  attr_reader :card_player
  attr_reader :card_machine
    
    def initialize
      @player_points = 0
      @machine_points = 0
      @golden_point_player = 0
      @golden_point_machine = 0
      
			@pack_parity = {
			  "6S"  => 6, "6H"  => 6, "6C"  => 6,  "6D"  => 6,  "7S" => 7,  "7H" => 7, "7C" => 7, "7D" => 7,
			  "8S"  => 8, "8H"  => 8, "8C"  => 8,  "8D"  => 8,  "9S" => 9,  "9H" => 9, "9C" => 9, "9D" => 9,
			  "10S" => 10,"10H" => 10,"10C" => 10, "10D" => 10, "JS" => 2,  "JH" => 2, "JC" => 2,
			  "JD"  => 2, "QS"  => 3, "QH"  => 3,  "QC"  => 3,  "QD" => 3,  "KS" => 4, "KH" => 4,
			  "KC"  => 4, "KD"  => 4, "AS"  => 11, "AH"  => 11, "AC" => 11, "AD" => 11
			}
			
			@pack = [
			  "6S", "6H", "6C", "6D", "7S", "7H", "7C", "7D", "8S", "8H", "8C", "8D",
			  "9S", "9H", "9C", "9D", "10S", "10H", "10C", "10D", "JS",  "JH", "JC", "JD",
			  "QS", "QH", "QC", "QD", "KS", "KH", "KC", "KD", "AS", "AH", "AC", "AD"
			]
      
      @ace = [
        "AS", "AH", "AC", "AD"
      ]
      
      @card_suit = {
        "S" => 6, "H" => 3, "C" => 5, "D" => 4
      }
		end
		
		
		def game
      puts "Приветствую тебя, игрок. Как твое имя?\n\n"
      name = gets.chomp
      
      puts "\n#{name}, сегодня мы с тобой будем играть в игру 21 (Очко).\n\nСейчас твой ход, нажми 'Enter'."
      gets.chomp
      
      distribution_cards_player
      distribution_cards_machine
      gameplay
      result_games
    end
    
    private
    
    def gameplay
      continue_game = true
      distribution = "Yes"
      
			while continue_game == true && player_points < 21 && machine_points < 21 || machine_points < 19 && player_points < 21
          
        if continue_game == true && player_points < 21
          puts "\nЖелаешь еще одну карту? Напиши 'Yes' или 'No'.\n\n"
          distribution = gets.chomp
            if distribution == "yes" || distribution == "Yes" 
              distribution_cards_player
            else
              continue_game = false
            end
        end	
        
        if machine_points < 19 && player_points < 21
          distribution_cards_machine
        end
      end
      
      puts "\nИгра окончена! У меня #{machine_points} очк#{ending_word_machine}, а у тебя #{player_points} очк#{ending_word_player}.\n\n"
    end
    
    def ending_word_player
      if player_points == 21 || player_points == 31 
        "о"
      elsif player_points >= 2 && player_points <= 4 || player_points >= 22 && player_points <= 24
        "а"
      elsif player_points >= 5 && player_points <= 20 || player_points >= 25 && player_points <= 30
        "ов"
      end
    end
    
    def ending_word_machine
      if machine_points == 21 || machine_points == 31
        "о"
      elsif machine_points >= 2 && machine_points <= 4 || machine_points >= 22 && machine_points <= 24
        "а"
      elsif machine_points >= 5 && machine_points <= 20 || machine_points >= 25 && machine_points <= 30
        "ов"
      end
    end
      
    def distribution_cards_player
      @card_player = @pack.sample
      @pack = @pack.delete_if{|card| card == @card_player}
      @player_points += @pack_parity[@card_player]
        if @ace.include?(@card_player)
          @golden_point_player += 1
        end
            
      puts "\nТебе выпала вот эта карта #{color_card_player}, у тебя #{player_points} очк#{ending_word_player}.\n"
    end
    
    def distribution_cards_machine
      puts "\nТеперь моя раздача:\n\n"
      
      @card_machine = @pack.sample
      @pack = @pack.delete_if{|card| card == @card_machine}
      @machine_points += @pack_parity[@card_machine]
      if @ace.include?(@card_machine)
          @golden_point_machine += 1
        end
      
      puts "Мне выпала вот эта карта #{color_card_machine}, у меня #{machine_points} очк#{ending_word_machine}.\n"
    end
    
    def color_card_player
      color_card = @card_player.chars
      color_card.pop
      color_card.join + @card_suit[@card_player.chars.last].chr
    end
    
    def color_card_machine
      color_card = @card_machine.chars
      color_card.pop
      color_card.join + @card_suit[@card_machine.chars.last].chr
    end
    
    def result_games
      if golden_point_player_win
        puts "У тебя 'золотое очко'. Ты победитель!"
      elsif golden_point_machine_win
        puts "У меня 'золотое очко'. Сегодня победа за мной!"
      elsif black_jack_player
        puts "Ты победитель!"
      elsif black_jack_machine
        puts "Сегодня победа за мной!"
      elsif draw
        puts "У нас с тобой ничья!"
      elsif bust_machine
        puts "Ты победитель!"
      elsif bust_player
        puts "Сегодня победа за мной!"
      elsif both_gleaning
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
	
	black_jack = BlackJack.new
	black_jack.game