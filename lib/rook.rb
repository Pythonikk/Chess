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
end
