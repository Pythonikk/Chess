# frozen_string_literal: true

# defines the Rooks behavior
class Rook < Piece
  def moves
    reset_moves

    squares << column_moves(8, 1)
    squares << column_moves(1, -1)
    squares << row_moves('a', -1)
    squares << row_moves('h', 1)

    format_squares
  end
end
