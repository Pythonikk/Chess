# frozen_string_literal: true

require 'colorize'
require 'colorized_string'

# the game board
class Board
  class << self
    attr_reader :squares
  end

  @squares = []

  def initialize
    create
  end

  COLUMNS = %w[a b c d e f g h].freeze
  COLORS = %i[black white].freeze

  # alter should be in pos or neg numbers
  def self.column(current_column, alter)
    index = COLUMNS.find_index(current_column)
    COLUMNS[index + alter]
  end

  def create(pos = ['a', 8], color = :white)
    return if pos == ['a', 0]

    loop do
      Board.squares << Square.new(pos.join('').to_sym, color)
      break if pos[0] == 'h'

      pos[0] = Board.column(pos[0], 1)
      color = COLORS.reject { |c| c == color }[0]
    end
    pos[1] -= 1
    create(['a', pos[1]], color)
  end

  def display
    print_column_letters
    row = 8
    until row.zero?
      print_row(row)
      row -= 1
    end
    print_column_letters
  end

  def print_column_letters
    columns = %w[a b c d e f g h]
    i = 0
    until i == 8
      print "   #{columns[i]}"
      i += 1
    end
    puts "\n"
  end

  def print_row(row)
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

  def white_square(square)
    if square.occupied?
      color = square.occupied_by.color
      piece = Pieces::SYMBOL[square.occupied_by.type]
    end
    occupied_square = " #{piece}  ".colorize(:color => color, :background => :light_blue)

    empty_square = '    '.colorize(:background => :light_blue)

    return occupied_square if square.occupied?

    empty_square
  end

  def black_square(square)
    if square.occupied?
      color = square.occupied_by.color
      piece = Pieces::SYMBOL[square.occupied_by.type]
    end
    occupied_square = " #{piece}  ".colorize(:color => color, :background => :blue)

    empty_square = '    '.colorize(:background => :blue)

    return occupied_square if square.occupied?

    empty_square
  end
end
