# frozen_string_literal: true

# defines types of movement that some pieces share/
# to be included in Piece class.
module Movement
  # bishop and queen
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

  # rook and queen
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
