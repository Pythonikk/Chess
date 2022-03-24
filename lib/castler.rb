# frozen_string_literal: true

# defines the behavior of a castling move between the rook and king
class Castler
  attr_reader :piece, :player, :opponent, :direction, :rook, :landing

  def initialize(piece, player, opponent, landing)
    @piece = piece
    @player = player
    @opponent = opponent
    @landing = landing
    return unless attempt?

    @direction = find_direction
    @rook = find_rook
  end

  def rook_square
    col = if direction == :queenside
            # rook moves three squares to the right
            Board.column(rook.current_pos[0], 3)
          else
            # rook moves two squares to the left
            Board.column(rook.current_pos[0], -2)
          end

    pos = (col + rook.current_pos[1]).to_sym
    Square.find_by_pos(pos)
  end

  def find_direction
    if Board::COLUMNS.index(piece.current_pos[0]) < Board::COLUMNS.index(landing.pos[0])
      :kingside
    else
      :queenside
    end
  end

  def find_rook
    direction == :queenside ? queenside_rook : kingside_rook
  end

  def queenside_rook
    player.pieces.select { |p| p.is_a?(Rook) && p.start_pos[0] == 'a' }[0]
  end

  def kingside_rook
    player.pieces.select { |p| p.is_a?(Rook) && p.start_pos[0] == 'h' }[0]
  end

  def square_jumped
    alter = direction == :queenside ? -1 : 1
    col = Board.column(piece.current_pos[0], alter)
    Square.find_by_pos((col + piece.current_pos[1]).to_sym)
  end

  def jumped_square_under_attack?
    opponent.pieces.each do |piece|
      return true if piece.moves.any? { |m| m == square_jumped.pos }
    end
    false
  end

  def rook_in_position?
    player.pieces.include?(rook) && rook.current_pos == rook.start_pos
  end

  def attempt?
    piece.is_a?(King) && moving_two_squares? &&
      rook_in_position?
  end

  # def valid_castling?
  #   piece.first_move? && rook.first_move? &&
  #     evaluator.path_clear?(piece, rook.current_pos) &&
  #     piece.in_check == false &&
  #     !@evaluator.puts_in_check? &&
  #     !jumped_square_under_attack?
  # end

  def moving_two_squares?
    return false unless within_row?

    Board.column(piece.current_pos[0], 2) == landing.pos[0] ||
      Board.column(piece.current_pos[0], -2) == landing.pos[0]
  end

  def within_row?
    landing.pos[1] == piece.current_pos[1]
  end
end
