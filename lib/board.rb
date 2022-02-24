# frozen_string_literal: true

require 'colorize'
require 'colorized_string'

# the game board
class Board
  class << self
    attr_reader :squares
  end

  @squares = []

  def initialize; end

  def display
    4.times do
      4.times do
        print white_square, black_square
      end
      puts "\n"
      4.times do
        print black_square, white_square
      end
      puts "\n"
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
