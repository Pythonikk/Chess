# frozen_string_literal: true

# abstract superclass
class Piece
  attr_reader :color, :start_pos, :current_pos,
              :cp1, :cp2, :squares, :type

  def initialize(type, color, start_pos)
    @type = type
    @color = color
    @start_pos = start_pos
    @current_pos = start_pos
    abbreviate
  end

  def abbreviate
    @cp1 = current_pos[0]
    @cp2 = current_pos[1].to_i
  end

  def format_squares
    squares.map! { |i| i.join('').to_sym }
  end
end
