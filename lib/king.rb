# frozen_string_literal: true

# defines the kings behavior
class King
  attr_reader :type, :color, :start_pos, :current_pos,
              :cp1, :cp2, :squares

  def initialize(type, color, pos)
    @type = type
    @color = color
    @pos = pos
    @current_pos = pos
    abbreviate
  end

  def abbreviate
    @cp1 = current_pos[0]
    @cp2 = current_pos[1].to_i
  end

  def moves
    @squares = []

    right_column = Board.column(cp1, 1)
    left_column = Board.column(cp1, -1)
    rows = [cp2 - 1, cp2, cp2 + 1]

    rows.each do |row|
      squares << [right_column, row]
      squares << [cp1, row]
      squares << [left_column, row]
    end

    format_squares
  end

  def format_squares
    squares.map! { |i| i.join('').to_sym }
           .reject! { |i| i == current_pos }
  end
end
