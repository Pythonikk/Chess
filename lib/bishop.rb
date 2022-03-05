# frozen_string_literal: true

# defines the Bishops behavior
class Bishop < Piece
  def moves
    reset_moves

    # north_left_diagonal
    squares << diagonal({ column: 'a', row: 8 }, -1, 1)
    # north_right_diagonal
    squares << diagonal({ column: 'h', row: 8 }, 1, 1)
    # south_left_diagonal
    squares << diagonal({ column: 'a', row: 1 }, -1, -1)
    # south_right_diagonal
    squares << diagonal({ column: 'h', row: 1 }, 1, -1)

    format_squares
  end
end
