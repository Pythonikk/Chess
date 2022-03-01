# frozen_string_literal: true

# defines the Pawns behavior
class Pawn < Piece
  def moves
    @squares = []
    squares << forward_move
    squares << starting_move
    format_squares
  end

  def starting_move
    arr = []
    if color == :white
      arr << [cp1, cp2 + 1] # one forward move
      arr << [cp1, cp2 + 2]
    else
      arr << [cp1, cp2 - 1] # one forward move
      arr << [cp1, cp2 - 2]
    end
    arr
  end

  def forward_move
    return [[cp1, cp2 + 1]] if color == :white
    return [[cp1, cp2 - 1]] if color == :black
  end

  # can move diagonally to capture
  def capture_moves
    right_column = Board.column(cp1, 1)
    left_column = Board.column(cp1, -1)

    [[right_column, cp2 + 1], [left_column, cp2 + 1]]
  end
end
