# frozen_string_literal: true

# defines the Rooks behavior
class Rook
  attr_reader :type, :color, :start_pos, :current_pos,
              :cp1, :cp2, :squares

  def initialize(type, color, pos)
    @type = type
    @color = color
    @pos = pos
    @current_pos = pos
    abbreviate
  end

  def abbreviate
    @cp1 = current_pos[0]
    @cp2 = current_pos[1].to_i
  end

  def moves
    @squares = []
    north_moves
    south_moves
    row_left_moves
    row_right_moves
    squares
  end

  def north_moves
    row = cp2
    until row == 8
      row += 1
      squares << [cp1, row]
    end
  end

  def south_moves
    row = cp2
    until row == 1
      row -= 1
      squares << [cp1, row]
    end
  end

  def row_left_moves
    column = cp1
    until column == 'a'
      column = Board.column(column, -1)
      squares << [column, cp2]
    end
  end

  def row_right_moves
    column = cp1
    until column == 'h'
      column = Board.column(column, 1)
      squares << [column, cp2]
    end
  end
end
