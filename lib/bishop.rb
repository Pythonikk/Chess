# frozen_string_literal: true

# defines the Bishops behavior
class Bishop < Piece
  def moves
    @squares = []

    # north_left_diagonal
    diagonal({ column: 'a', row: 8 }, -1, 1)
    # north_right_diagonal
    diagonal({ column: 'h', row: 8 }, 1, 1)
    # south_left_diagonal
    diagonal({ column: 'a', row: 1 }, -1, -1)
    # south_right_diagonal
    diagonal({ column: 'h', row: 1 }, 1, -1)

    format_squares
  end

  def diagonal(limit, c_alter, r_alter)
    column = cp1
    row = cp2

    until column == limit[:column] || row == limit[:row]
      column = Board.column(column, c_alter)
      row += r_alter
      squares << [column, row]
    end
  end
end
