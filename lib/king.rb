# frozen_string_literal: true

# defines the kings behavior
class King < Piece
  def moves
    reset_moves

    right_column = Board.column(cp1, 1)
    left_column = Board.column(cp1, -1)
    rows = [cp2 - 1, cp2, cp2 + 1]

    rows.each do |row|
      squares << [[right_column, row]]
      squares << [[cp1, row]]
      squares << [[left_column, row]]
    end

    format_squares
  end
end
