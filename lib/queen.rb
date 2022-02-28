# frozen_string_literal: true

# defines the Queens behavior
class Queen < Piece
  def moves
    @squares = []

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

  def column_moves(limit, alter)
    arr = []
    row = cp2
    until row == limit
      row += alter
      arr << [cp1, row]
    end
    arr unless arr.empty?
  end

  def row_moves(limit, alter)
    arr = []
    column = cp1
    until column == limit
      column = Board.column(column, alter)
      arr << [column, cp2]
    end
    arr unless arr.empty?
  end

  def diagonal(limit, c_alter, r_alter)
    arr = []
    column = cp1
    row = cp2

    until column == limit[:column] || row == limit[:row]
      column = Board.column(column, c_alter)
      row += r_alter
      arr << [column, row]
    end
    arr unless arr.empty?
  end
end
