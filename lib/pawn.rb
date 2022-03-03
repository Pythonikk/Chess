# frozen_string_literal: true

# defines the Pawns behavior
class Pawn < Piece
  attr_accessor :en_passant

  def moves
    reset_moves
    squares << forward_move
    squares << starting_move if first_turn
    squares << capture_moves
    format_squares
  end

  def first_turn
    current_pos == start_pos
  end

  def starting_move
    arr = []
    if color == :white
      arr << [cp1, cp2 + 1] # one forward move
      arr << [cp1, cp2 + 2]
    else
      arr << [cp1, cp2 - 1] # one forward move
      arr << [cp1, cp2 - 2]
    end
    arr
  end

  def forward_move
    return [[cp1, cp2 + 1]] if color == :white
    return [[cp1, cp2 - 1]] if color == :black
  end

  # can move diagonally to capture
  def capture_moves
    right_column = Board.column(cp1, 1)
    left_column = Board.column(cp1, -1)

    return [[right_column, cp2 + 1], [left_column, cp2 + 1]] if color == :white
    return [[right_column, cp2 - 1], [left_column, cp2 - 1]] if color == :black
  end

  def double_step?(old_pos)
    row = old_pos[1].to_i
    [row + 2, row - 2].include?(cp2)
  end

  # has moved forward two and landed next to an enemy pawn
  def giving_en_passant?(old_pos)
    return unless double_step?(old_pos)

    neighbor[:east] || neighbor[:west]
  end

  def opponent_pawn(square)
    return square.occupied_by if square.occupied_by.is_a?(Pawn) &&
                                 square.occupied_by.color != color
  end

  def square(position)
    Board.squares.select { |s| s.position == position }[0]
  end

  def neighbor
    n = { north: [cp1, cp2 + 1],
          east: [Board.column(cp1, 1), cp2],
          south: [cp1, cp2 - 1],
          west: [Board.column(cp1, -1), cp2] }

    n.each { |k, v| n[k] = opponent_pawn(square(v.join('').to_sym)) }
  end

  def give_en_passant
    pawn = neighbor[:east] || neighbor[:west]
    pawn.en_passant = true
  end

  def taking_en_passant?(new_pos)
    @en_passant == true &&
      new_pos[0] != current_pos[0]
  end
end
