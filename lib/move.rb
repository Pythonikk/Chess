# frozen_string_literal: true

# handles the behavior of a move made by player
class Move
  # class << self
  #   attr_accessor :record
  # end

  # # all the moves made in a game
  # @record = []

  attr_reader :player, :move, :piece, :landing_square

  def initialize(player)
    @player = player
    puts "#{player.color.to_s.capitalize}'s turn!"
    initiate
    # Move.record << move
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
    return :occupied_landing unless unoccupied_landing?
    return :obstructed_path unless path_clear?

    # there are no pieces in the way if piece doesnt hop
    # piece can't move that way, could print out where a piece can move
    # if castling then valid castling?
    # if pawn then taking en-passant?
    # move does not put players own king in check
  end

  def path_clear?
    path.each do |pos|
      return false unless square(pos).occupied_by.nil?
    end
    true
  end

  def path
    way = piece.moves
               .select { |array| array.include?(landing_square.position) }
               .flatten
    index = way.find_index(landing_square.position)
    way[0..index]
  end

  def unoccupied_landing?
    landing_square.occupied_by.nil?
  end

  def display_move_error(error)
    case error
    when :wrong_color
      puts "Select a #{player.color.to_s.capitalize} piece to move."
    when :occupied_landing
      puts "You already occupy the square you're trying to move to."
    when :obstructed_path
      puts "The path to #{landing_square.position} is obstructed."
    end
  end

  def players_piece?
    piece.color == player.color
  end

  # returns the square at position
  def square(position)
    square = Board.squares.select { |s| s.position == position }[0]
    return square if square

    puts 'An invalid square was entered'
  end

  def player_input
    puts 'What position do you want to move from and to where?'
    # player should input like 'b3 c5'
    input = gets.chomp.split(' ').map(&:to_sym)
    return input if valid?(input)

    player_input
  end

  def valid?(input)
    square(input[0]) && square(input[1])
  end
end
