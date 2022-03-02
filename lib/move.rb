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
    # update piece position
    piece.current_pos = landing_square.position
    # update square occupation status
    landing_square.occupied_by = piece
    # old square now unoccupied
    square(move[0]).occupied_by = nil

    give_check if move_gives_check?
  end

  def initiate
    @move = player_input
    @piece = square(move[0]).occupied_by
    @landing_square = square(move[1])

    return unless evaluate_move.is_a?(Symbol)

    display_move_error(evaluate_move)
    initiate
  end

  def evaluate_move
    return :wrong_color unless players_piece?
    return :invalid_movement unless valid_movement?
    return :obstructed_path unless path_clear?
    return :occupied_landing unless unoccupied_landing?

    if in_check?
      return :in_check if puts_in_check?
    elsif puts_in_check?
      return :checks_self
    end

    return :illegal_pawn if pawn_diagonal? && !pawn_capture?

    # if castling then valid castling?
    # if pawn then taking en-passant?
  end

  def display_move_error(error)
    case error
    when :wrong_color
      puts "=> Select a #{player.color.to_s.capitalize} piece to move."
    when :occupied_landing
      puts "=> You already occupy the square you're trying to move to."
    when :obstructed_path
      puts "=> The path to #{landing_square.position} is obstructed."
    when :invalid_movement
      puts "=> Might be time to review how a #{piece.class} moves."
    when :illegal_pawn
      puts '=> Your pawn cannot move diagonally without capturing.'
    when :in_check
      puts '=> Your King is in check. You must move or guard him.'
    when :checks_self
      puts '=> That move is illegal, it puts your King in check.'
    end
  end

  def in_check?
    player.in_check == true
  end

  def remove_check
    player.in_check = false
  end

  def give_check
    opponent.in_check = true
    puts "***#{opponent.color.capitalize} is in check ***"
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

  def players_piece?
    piece.color == player.color
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
