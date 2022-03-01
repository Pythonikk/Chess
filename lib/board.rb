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
end
