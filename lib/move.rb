# frozen_string_literal: true

# handles the behavior of a move made by player
class Move
  attr_reader :player, :move, :piece, :landing_square, :opponent

  def initialize(player, opponent)
    @player = player
    @opponent = opponent
    puts "#{player.color.to_s.capitalize}'s turn!"
    initiate
    capture if capture?
    update_state
  end

  def update_state
    # update piece position
    piece.current_pos = landing_square.position
    # update square occupation status
    landing_square.occupied_by = piece
    # old square now unoccupied
    square(move[0]).occupied_by = nil
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
    return unless pawn_diagonal?

    return :illegal_pawn unless pawn_capture?

    # if castling then valid castling?
    # if pawn then taking en-passant?
    # move does not put players own king in check
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
      puts "=> Your pawn cannot move diagonally without capturing."
    end
  end

  def capture?
    landing_square.occupied?
  end

  def capture
    opponent.graveyard << landing_square.occupied_by
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

  def path_clear?
    return true unless path_required?

    path.each do |pos|
      return false unless square(pos).occupied_by.nil?
    end
    true
  end

  # if piece only moves one square, don't call path
  def path_required?
    return false if piece.is_a?(Knight) || piece.is_a?(King)

    next_to_columns = [Board.column(piece.cp1, -1), Board.column(piece.cp1, 1)]
    next_to_rows = [piece.cp2 + 1, piece.cp2 - 1]

    return true unless next_to_columns.include?(landing_square.position[0]) ||
                       next_to_rows.include?(landing_square.position[1].to_i)
  end

  # path only works for pieces moving more than one square away
  def path
    way = piece.moves
               .select { |array| array.include?(landing_square.position) }
               .flatten
    index = way.find_index(landing_square.position)
    # the landing square could be a capture so don't count it in path
    way[0..(index - 1)]
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
    # player should input like 'b3 c5'
    input = gets.chomp.split(' ').map(&:to_sym)
    return input if valid?(input)

    player_input
  end

  def valid?(input)
    square(input[0]) && square(input[1])
  end
end
