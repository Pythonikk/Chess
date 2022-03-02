# frozen_string_literal: true

require 'colorize'
require 'colorized_string'

# handles what gets printed in the terminal
class Display
  def self.output
    puts'-------------------------------------'
    display_graveyard(:black)
    print_column_letters
    row = 8
    until row.zero?
      print_row(row)
      row -= 1
    end
    print_column_letters
    display_graveyard(:white)
    puts'-------------------------------------'
  end

  def self.display_graveyard(color)
    graveyard(color).map! { |p| Pieces::SYMBOL[p.class.to_s.downcase.to_sym] }
    puts " #{headstone}  #{graveyard(color).join('')}".colorize(color: color)
  end


  def self.graveyard(color)
    ObjectSpace.each_object(Player).to_a
               .select { |p| p.color == color }[0]
               .graveyard
  end

  def self.headstone
    "\u{1FAA6}"
  end

  def self.print_column_letters
    columns = %w[a b c d e f g h]
    i = 0
    until i == 8
      print "   #{columns[i]}"
      i += 1
    end
    puts "\n"
  end

  def self.print_row(row)
    print "#{row} "
    in_row = Board.squares.select { |s| s.position[1].to_i == row }
    in_row.each do |square|
      if square.color == :white
        print white_square(square)
      else
        print black_square(square)
      end
    end
    print " #{row}"
    puts "\n"
  end

  def self.color(square)
    square.occupied_by.color
  end

  def self.symbol(square)
    Pieces::SYMBOL[square.occupied_by.class.to_s.downcase.to_sym]
  end

  def self.white_square(square)
    if square.occupied?
      " #{symbol(square)}  ".colorize(color: color(square), background: :light_blue)
    else
      '    '.colorize(background: :light_blue)
    end
  end

  def self.black_square(square)
    if square.occupied?
      " #{symbol(square)}  ".colorize(color: color(square), background: :blue)
    else
      '    '.colorize(background: :blue)
    end
  end
end
