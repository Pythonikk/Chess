# frozen_string_literal: true

# defines the Knights behavior
class Knight
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

    alterations.each do |a|
      column = Board.column(cp1, a[0])
      row = cp2 + a[1]
      squares << [column, row]
    end
    format_squares
  end

  def alterations
    [[1, 2], [2, 1], [2, -1], [1, -2],
     [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
  end

  def format_squares
    squares.map! { |i| i.join('').to_sym }
  end
end
