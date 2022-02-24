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
    display
  end

  def create(pos = ['a', 8], color = :white)
    return if pos == ['a', 0]

    columns = %w[a b c d e f g h]
    colors = [:black, :white]
    loop do
      Board.squares << Square.new(pos.join('').to_sym, color)
      break if pos[0] == 'h'

      index = columns.find_index(pos[0])
      pos[0] = columns[index + 1]
      color = colors.reject { |c| c == color }[0]
    end
    pos[1] -= 1
    create(['a', pos[1]], color)
  end

  def display
    last_row = 0
    Board.squares.each do |square|
      current_row = square.position[1].to_i
      puts "\n" if current_row < last_row
      if square.color == :white
        print white_square
      else
        print black_square
      end
      last_row = current_row
    end
  end

  def white_square(occupied = false, piece = KNIGHT)
    occupied_square = " #{piece}  ".colorize(:color => :black, :background => :white)
    empty_square = '    '.colorize(:background => :white)

    return occupied_square if occupied

    empty_square
  end

  def black_square(occupied = false, piece = KNIGHT)
    # piece.color
    occupied_square = " #{piece}  ".colorize(:color => :white, :background => :light_black)
    empty_square = '    '.colorize(:background => :light_black)

    return occupied_square if occupied

    empty_square
  end

  # TEMP for testing
  KNIGHT = "\u{265E}".freeze
end
