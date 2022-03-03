# frozen_string_literal: true

# handles the behavior of a move made by player
class Move
  attr_reader :player, :move, :piece, :landing_square, :opponent

  def initialize(player, opponent)
    @player = player
    @opponent = opponent
    puts "#{player.color.to_s.capitalize}'s turn!"
    initiate
    update_state
  end

  def update_state
    capture if capture?
    piece.current_pos = landing_square.position
    landing_square.occupied_by = piece
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

  def mated?
    opponent.graveyard.any? { |piece| piece.is_a?(King) }
  end

  def mate
    Game.mate = true
    puts "*** #{player.color.capitalize} wins! ***"
  end

  def initiate
    @move = player_input
    @piece = square(move[0]).occupied_by
    @landing_square = square(move[1])

    if piece.is_a?(Pawn) &&
       piece.taking_en_passant?(landing_square.position)
      pawn_en_passant
      return
    end

    error = evaluate
    return unless error

    Display.move_error(error)
    initiate
  end

  def general_error
    { players_piece?: [:wrong_color, player.color.to_s.capitalize],
      valid_movement?: [:invalid_movement, piece.class],
      path_clear?: [:obstructed_path, landing_square.position],
      unoccupied_landing?: :occupied_landing }
  end

  def check_error
    if in_check? && puts_in_check?
      :in_check
    elsif puts_in_check?
      :checks_self
    end
  end

  def pawn_error
    if pawn_diagonal? && !pawn_capture?
      :illegal_pawn
    elsif blocked_forward?
      :blocked
    end
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

  def pawn_en_passant
    piece.current_pos = landing_square.position
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

  def move_gives_check?
    player.pieces.each do |pp|
      next unless pp.moves.any? { |m| m.include?(opponent.king_pos) }

      return true unless path_required?(pp, opponent.king_pos)

      path(pp, opponent.king_pos).each do |pos|
        next unless square(pos).occupied_by.nil?

        return true
      end
    end
    false
  end

  def puts_in_check?(king_pos = player.king_pos)
    king_pos = landing_square.position if piece.is_a?(King)

    opponent.pieces.each do |op|
      next unless op.moves.any? { |m| m.include?(king_pos) }

      return true unless path_required?(op, king_pos)

      path(op, king_pos).each do |pos|
        next unless square(pos).occupied_by.nil?

        return true
      end
    end
    false
  end

  def path_clear?
    return true unless path_required?

    path.each do |pos|
      return false unless square(pos).occupied_by.nil?
    end
    true
  end

  # if piece only moves one square, don't call path
  def path_required?(piece = @piece, position = landing_square.position)
    return false if piece.is_a?(Knight) || piece.is_a?(King)

    next_to_columns = [Board.column(piece.cp1, -1), Board.column(piece.cp1, 1)]
    next_to_rows = [piece.cp2 + 1, piece.cp2 - 1]

    return true unless next_to_columns.include?(position[0]) ||
                       next_to_rows.include?(position[1].to_i)
  end

  # path only works for pieces moving more than one square away
  def path(piece = @piece, position = landing_square.position)
    way = piece.moves
               .select { |array| array.include?(position) }
               .flatten
    index = way.find_index(position)
    # the landing square could be a capture so don't count it in path
    way[0..(index - 1)]
  end

  def capture?
    landing_square.occupied?
  end

  def capture
    opponent.graveyard << landing_square.occupied_by
    opponent.pieces.reject! { |piece| piece == landing_square.occupied_by }
  end

  def pawn_diagonal?
    piece.is_a?(Pawn) &&
      landing_square.position[0] != piece.current_pos[0]
  end

  def pawn_capture?
    return true if landing_square.occupied?

    false
  end

  def pawn_forward?
    true unless pawn_diagonal?
  end

  # for pawns
  def blocked_forward?
    piece.is_a?(Pawn) && pawn_forward? &&
      landing_square.occupied?
  end

  # returns the square at position
  def square(position)
    square = Board.squares.select { |s| s.position == position }[0]
    return square if square

    puts 'An invalid square was entered'
  end

  def valid_movement?
    return true if piece.moves[0].is_a?(Array) &&
                   piece.moves.any? { |m| m.include?(landing_square.position) } ||
                   piece.moves.include?(landing_square.position)

    false
  end

  def unoccupied_landing?
    landing_square.occupied_by.nil? ||
      landing_square.occupied_by.color != player.color
  end

  # why do i get an error on this sometimes?
  def players_piece?
    @piece.color == @player.color
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
