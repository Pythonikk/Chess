# frozen_string_literal: true

# defines the Rooks behavior
class Rook < Piece
  def moves
    @squares = []

    column_moves(8, 1)
    column_moves(1, -1)
    row_moves('a', -1)
    row_moves('h', 1)

    format_squares
  end

  def column_moves(limit, alter)
    row = cp2
    until row == limit
      row += alter
      squares << [cp1, row]
    end
  end

  def row_moves(limit, alter)
    column = cp1
    until column == limit
      column = Board.column(column, alter)
      squares << [column, cp2]
    end
  end
end
