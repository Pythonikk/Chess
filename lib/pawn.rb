# frozen_string_literal: true

# defines the Pawns behavior
class Pawn < Piece
  def moves
    @squares = []
    starting_move
    forward_move
    format_squares
  end

  def starting_move
    squares << [cp1, cp2 + 2]
  end

  def forward_move
    arr = []
    arr << starting_move
    arr << [cp1, cp2 + 1]
    squares << arr
  end

  # can move diagonally to capture
  def capture_moves
    right_column = Board.column(cp1, 1)
    left_column = Board.column(cp1, -1)

    [[right_column, cp2 + 1], [left_column, cp2 + 1]]
  end
end
