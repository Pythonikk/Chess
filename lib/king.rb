# frozen_string_literal: true

# defines the kings behavior
class King < Piece
  def moves
    @squares = []

    right_column = Board.column(cp1, 1)
    left_column = Board.column(cp1, -1)
    rows = [cp2 - 1, cp2, cp2 + 1]

    rows.each do |row|
      squares << [right_column, row]
      squares << [cp1, row]
      squares << [left_column, row]
    end

    format_squares
  end

  def format_squares
    super.reject! { |i| i == current_pos }
  end
end
