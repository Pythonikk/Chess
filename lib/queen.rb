# frozen_string_literal: true

# defines the Queens behavior
class Queen
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

    column_moves(8, 1)
    column_moves(1, -1)
    row_moves('a', -1)
    row_moves('h', 1)
    # north_left_diagonal
    diagonal({ column: 'a', row: 8 }, -1, 1)
    # north_right_diagonal
    diagonal({ column: 'h', row: 8 }, 1, 1)
    # south_left_diagonal
    diagonal({ column: 'a', row: 1 }, -1, -1)
    # south_right_diagonal
    diagonal({ column: 'h', row: 1 }, 1, -1)
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
