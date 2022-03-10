# frozen_string_literal: true

# abstract superclass
class Piece
  include Movement

  attr_reader :color, :start_pos, :cp1, :cp2, :squares
  attr_accessor :current_pos

  def initialize(color, start_pos)
    @color = color
    @start_pos = start_pos
    @current_pos = start_pos
    abbreviate
  end

  def reset_moves
    @squares = []
    abbreviate
  end

  private

  def moves
    raise NotImplementedError, "#moves for instance of #{self.class}..."
  end

  def abbreviate
    @cp1 = current_pos[0]
    @cp2 = current_pos[1].to_i
  end

  def format_squares
    squares.compact!
    if squares[0][0].is_a?(Array)
      squares.each do |array|
        array.map! { |i| i.join('').to_sym }
      end
    else
      squares.map! { |i| i.join('').to_sym }
    end
  end
end
