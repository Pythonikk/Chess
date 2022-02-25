# frozen_string_literal: true

# defines the Pawns behavior
class Pawn
  attr_reader :type, :color, :start_pos, :current_pos

  def initialize(type, color, pos)
    @type = type
    @color = color
    @pos = pos
    @current_pos = pos
  end

  def moves
    arr = []

    cp1 = current_pos[0]
    cp2 = current_pos[1].to_i

    # can move two squares if in starting position
    arr << [cp1, cp2 + 2]

    arr << [cp1, cp2 + 1]

    arr.map! { |i| i.join('').to_sym }
  end

  # can move diagonally to capture
  def capture_move(cp1 = current_pos[0], cp2 = current_pos[1].to_i)
    right_column = Board.column(cp1, 1)
    left_column = Board.column(cp1, -1)

    [[right_column, cp2 + 1], [left_column, cp2 + 1]]
  end
end
