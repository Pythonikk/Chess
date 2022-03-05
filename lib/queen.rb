# frozen_string_literal: true

# defines the Queens behavior
class Queen < Piece
  def moves
    reset_moves

    squares << column_moves(8, 1)
    squares << column_moves(1, -1)
    squares << row_moves('a', -1)
    squares << row_moves('h', 1)
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
