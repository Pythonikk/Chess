# frozen_string_literal: true

# handles the behavior of a move made by player
class Move
  attr_reader :player, :move, :piece, :landing, :opponent, :castling

  def initialize(player, opponent)
    @player = player
    @opponent = opponent
    initiate
    return if Game.saved

    execute
  end

  private

  def set_vars
    @move = player_input
    return if Game.saved

    @piece = Square.find_by_pos(move[0]).occupied_by
    @landing = Square.find_by_pos(move[1])
    @castling = castling?
  end

  def initiate
    set_vars

    return if Game.saved
    return piece.take_en_passant(opponent, landing) if passant_move?

    @evaluator = Evaluator.new(self)
    error = @evaluator.error
    return unless error

    Display.move_error(error)
    initiate
  end

  def castling?
    @castler = Castler.new(piece, player, opponent, landing)
    @castler.attempt?
  end

  def update_state_rook
    Square.find_by_pos(@castler.rook.current_pos).update
    @castler.rook_square.occupied_by = @castler.rook
    @castler.rook.current_pos = @castler.rook_square.pos
  end

  def move_gives_check?
    player.pieces.each do |pp|
      next unless pp.moves.any? { |m| m.include?(opponent.king_pos) }

      return true if @evaluator.path_clear?(pp, opponent.king_pos)
    end
    false
  end

  def execute
    capture if capture?
    update_scoresheet
    update_state
    update_state_rook if castling
    return mate if mated?

    give_check if move_gives_check?
    pawn_privelage if piece.is_a?(Pawn)
  end

  def update_scoresheet
    Game.scoresheet << { piece: piece, from: piece.current_pos,
                         to: landing.pos }
  end

  def update_state
    piece.current_pos = landing.pos
    landing.occupied_by = piece
    Square.find_by_pos(move[0]).update
  end

  def pawn_privelage
    if piece.giving_en_passant?(move[0])
      piece.give_en_passant
    elsif piece.promotion?
      piece.promote(player)
    end
  end

  def passant_move?
    piece.is_a?(Pawn) &&
      piece.taking_en_passant?(landing.pos)
  end

  def remove_check
    player.in_check = false
  end

  def give_check
    opponent.in_check = true
    Display.in_check(opponent)
  end

  def capture?
    landing.occupied? &&
      landing.occupied_by.color != player.color
  end

  def capture
    opponent.piece_taken(landing.occupied_by)
  end

  def mated?
    opponent.graveyard.any? { |piece| piece.is_a?(King) }
  end

  def mate
    Game.mate = true
    Display.mate(player)
  end

  def player_input
    Display.move
    input = gets.chomp.downcase.split(' ').map(&:to_sym)
    return save_and_exit if input == [:save]
    return input if valid?(input)

    player_input
  end

  def valid?(input)
    Square.find_by_pos(input[0]) &&
      Square.find_by_pos(input[1])
  end

  def save_and_exit
    Game.save
    Game.saved = true
  end
end
