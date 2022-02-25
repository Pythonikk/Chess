# frozen_string_literal: true

# defines the kings behavior
class King
  attr_reader :type, :color, :start_pos, :current_pos

  def initialize(type, color, pos)
    @type = type
    @color = color
    @pos = pos
    @current_pos = pos
    Piece.settle_in(self)
  end

  def moves
    current_pos[0] + 1 ||
      current_pos[0] - 1 ||
      current_pos[1] + 1 ||
      current_pos[1] - 1
  end
end
