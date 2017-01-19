require_relative "black_jack"

class Printer
  def print
    puts "Приветствую тебя, игрок. Как твое имя?\n\n"
    name = gets.chomp

    puts "\n#{name}, сегодня мы с тобой будем играть в игру 21 (Очко).\n\nСейчас твой ход, нажми 'Enter'."
    gets.chomp

    black_jack = BlackJack.new
    black_jack.game
  end
end

printer = Printer.new
printer.print
