# frozen_string_literal: true

# defines the Knights behavior
class Knight < Piece
  def moves
    reset_moves

    alterations.each do |a|
      column = Board.column(cp1, a[0])
      row = cp2 + a[1]
      squares << [[column, row]]
    end
    format_squares
  end

  private

  def alterations
    [[1, 2], [2, 1], [2, -1], [1, -2],
     [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
  end
end
