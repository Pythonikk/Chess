# frozen_string_literal: true

# defines the Pawns behavior
class Pawn < Piece
  attr_accessor :en_passant

  def moves
    reset_moves
    squares << forward_move
    squares << double_step if first_move?
    squares << capture_move_left
    squares << capture_move_right
    format_squares
  end

  PROMOTIONS = { 1 => :queen, 2 => :bishop, 3 => :rook, 4 => :knight }.freeze

  def promotion?
    h = { white: '8', black: '1' }
    h[color] == current_pos[1]
  end

  def first_move?
    current_pos == start_pos
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

  def promote(player)
    selection = Display.promotion
    np = Pieces.give_character(selection, color, current_pos)
    player.pieces << np
    player.pieces.reject! { |pi| pi == self }
  end

  def take_en_passant(opponent, landing)
    self.current_pos = landing.pos
    self.en_passant = false

    opponent.piece_taken(taking_pawn)
    square = Square.find_by_occupant(taking_pawn)
    square.update
  end

  def taking_en_passant?(new_pos)
    @en_passant == true &&
      new_pos[0] != current_pos[0]
  end

  def give_en_passant
    pawn = neighbor[:east] || neighbor[:west]
    pawn.en_passant = true
  end

  private

  def double_step
    if color == :white
      [].push(forward_move).push([cp1, cp2 + 2])
    else
      [].push(forward_move).push([cp1, cp2 - 2])
    end
  end

  def forward_move
    return [[cp1, cp2 + 1]] if color == :white

    [[cp1, cp2 - 1]]
  end

  # def capture_move
  #   right_column = Board.column(cp1, 1)
  #   left_column = Board.column(cp1, -1)

  #   return [[right_column, cp2 + 1], [left_column, cp2 + 1]] if color == :white
  #   return [[right_column, cp2 - 1], [left_column, cp2 - 1]] if color == :black
  # end

  def capture_move_left
    left_column = Board.column(cp1, -1)

    return [[left_column, cp2 + 1]] if color == :white
    return [[left_column, cp2 - 1]] if color == :black
  end

  def capture_move_right
    right_column = Board.column(cp1, 1)

    return [[right_column, cp2 + 1]] if color == :white
    return [[right_column, cp2 - 1]] if color == :black
  end

  def opponent_pawn(square)
    # square will be nil if pawn is at edge of the board
    return nil if square.nil?
    return square.occupied_by if square.occupied_by.is_a?(Pawn) &&
                                 square.occupied_by.color != color
  end

  def adjacent
    { north: [cp1, cp2 + 1],
      east: [Board.column(cp1, 1), cp2],
      south: [cp1, cp2 - 1],
      west: [Board.column(cp1, -1), cp2] }
  end

  def neighbor
    abbreviate # resets cp1 and cp2
    h = adjacent
    h.each do |dir, pos|
      sq = Square.find_by_pos(pos.join('').to_sym)
      h[dir] = opponent_pawn(sq)
    end
  end

  def taking_pawn
    return neighbor[:south] if color == :white

    neighbor[:north]
  end
end
