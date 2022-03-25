# frozen_string_literal: true

require 'colorize'
require 'colorized_string'

# handles what gets printed in the terminal
class Display
  extend DisplayError

  def self.select_game
    puts 'Select game: [0]New Game  [1]Load Game'
  end

  def self.instructions
    puts 'When prompted to move, enter the square you wish to move from'\
    " and the square you wish to move to. Like so: f2 f4\n Enter 'save' to save the game.\n"
  end

  def self.move_error(error)
    if error.is_a?(Array)
      puts send(error[0], error[1])
    else
      puts send(error)
    end
  end

  def self.mate(player)
    puts "*** #{player.color.capitalize} wins! ***"
  end

  def self.in_check(player)
    puts "*** #{player.color.capitalize} is in check ***"
  end

  def self.move
    puts 'Move: '
  end

  def self.promotion
    puts 'Your pawn has been promoted! Select a promotion: '
    puts Pawn::PROMOTIONS.to_s
    selection
  end

  def self.output
    puts "\n"
    display_graveyard(:black)
    puts "\n"
    print_column_letters
    print_board
    print_column_letters
    display_graveyard(:white)
    puts "\n"
  end

  class << self
    private

    def selection
      input = gets.chomp.to_i
      return Pawn::PROMOTIONS[input] if Pawn::PROMOTIONS.keys.include?(input)

      puts 'Invalid input. Choose 1, 2, 3 or 4.'
      Display.selection
    end

    def print_board
      row = 8
      until row.zero?
        print_row(row)
        row -= 1
      end
    end

    def print_row(row)
      print "#{row} "
      in_row = Board.squares.select { |s| s.pos[1].to_i == row }
      print_squares(in_row)
      print " #{row}"
      puts "\n"
    end

    def print_squares(in_row)
      in_row.each do |square|
        if square.color == :white
          print white_square(square)
        else
          print black_square(square)
        end
      end
    end

    def display_graveyard(color)
      print " #{headstone}  "
      graveyard(color).map { |p| Pieces::SYMBOL[p.class.to_s.downcase.to_sym] }
                      .each { |g| print g.to_s.colorize(color: color) }
    end

    def graveyard(color)
      ObjectSpace.each_object(Player).to_a
                 .select { |p| p.color == color }[0]
                 .graveyard
    end

    def headstone
      "\u{1FAA6}"
    end

    def print_column_letters
      i = 0
      until i == 8
        print "   #{Board::COLUMNS[i]}"
        i += 1
      end
      puts "\n"
    end

    def color(square)
      square.occupied_by.color
    end

    def symbol(square)
      Pieces::SYMBOL[square.occupied_by.class.to_s.downcase.to_sym]
    end

    def white_square(square)
      if square.occupied?
        " #{symbol(square)}  ".colorize(color: color(square), background: :light_blue)
      else
        '    '.colorize(background: :light_blue)
      end
    end

    def black_square(square)
      if square.occupied?
        " #{symbol(square)}  ".colorize(color: color(square), background: :blue)
      else
        '    '.colorize(background: :blue)
      end
    end
  end
end
