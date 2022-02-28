# frozen_string_literal: true

# abstract superclass
class Piece
  attr_reader :color, :start_pos, :current_pos,
              :cp1, :cp2, :squares

  def initialize(color, start_pos)
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
    squares.compact!
    squares.each do |array|
      array.map! { |i| i.join('').to_sym }
    end
  end

  def update_position(pos)
    self.current_pos = pos
  end
end
