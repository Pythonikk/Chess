# frozen_string_literal: true

# handles the behavior of a move made by player
class Move
  include MoveError
  attr_reader :player, :move, :piece, :landing, :opponent

  def initialize(player, opponent)
    @player = player
    @opponent = opponent
    initiate
    update_state
  end

  def set_vars
    @move = player_input
    @piece = square(move[0]).occupied_by
    @landing = square(move[1])
  end

  def initiate
    set_vars
    return pawn_en_passant if passant_move?

    error = evaluate
    return unless error

    Display.move_error(error)
    initiate
  end

  def evaluate
    general_error.each do |method, response|
      conditions_pass = send(method)
      return response unless conditions_pass
    end
    return check_error unless check_error.nil?
    return nil unless piece.is_a?(Pawn)

    pawn_error
  end

  def path(piece = @piece, position = landing.pos)
    way = piece.moves
               .select { |array| array.include?(position) }
               .flatten
    index = way.find_index(position)
    way[0..index]
  end

  def move_gives_check?
    player.pieces.each do |pp|
      next unless pp.moves.any? { |m| m.include?(opponent.king_pos) }

      return true if path_clear?(pp, opponent.king_pos)
    end
    false
  end

  def update_state
    capture if capture?
    piece.current_pos = landing.pos
    landing.occupied_by = piece
    square(move[0]).occupied_by = nil

    return mate if mated?

    give_check if move_gives_check?
    return unless piece.is_a?(Pawn)

    piece.give_en_passant if piece.giving_en_passant?(move[0])
    promote if piece.promotion?
  end

  def promote
    role = piece.promote
    np = Pieces.give_character(role, player.color, piece.current_pos)
    player.pieces << np
    player.pieces.reject! { |pi| pi == piece }
  end

  def passant_move?
    piece.is_a?(Pawn) &&
      piece.taking_en_passant?(landing.pos)
  end

  def pawn_en_passant
    piece.current_pos = landing.pos
    # using this to reset cp1 and cp2 for now
    piece.abbreviate
    piece.en_passant = false

    taking_pawn = piece.neighbor[:south] if piece.color == :white
    taking_pawn = piece.neighbor[:north] if piece.color == :black

    opponent.graveyard << taking_pawn
    opponent.pieces.reject! { |piece| piece == taking_pawn }
    s = Board.squares.select { |sq| sq.occupied_by == taking_pawn }[0]
    s.occupied_by = nil
  end

  def in_check?
    player.in_check == true
  end

  def remove_check
    player.in_check = false
  end

  def give_check
    opponent.in_check = true
    puts "*** #{opponent.color.capitalize} is in check ***"
  end

  def capture?
    landing.occupied? &&
      landing.occupied_by.color != player.color
  end

  def capture
    opponent.graveyard << landing.occupied_by
    opponent.pieces.reject! { |piece| piece == landing.occupied_by }
  end

  def mated?
    opponent.graveyard.any? { |piece| piece.is_a?(King) }
  end

  def mate
    Game.mate = true
    puts "*** #{player.color.capitalize} wins! ***"
  end

  # returns the square at position
  def square(position)
    square = Board.squares.select { |s| s.pos == position }[0]
    return square if square

    puts 'An invalid square was entered'
  end

  def player_input
    puts 'Move: '
    input = gets.chomp.split(' ').map(&:to_sym)
    return input if valid?(input)

    player_input
  end

  def valid?(input)
    square(input[0]) && square(input[1])
  end
end
