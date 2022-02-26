# frozen_string_literal: true

# handles the behavior of a move made by player
class Move
  class << self
    attr_accessor :record
  end

  # all the moves made in a game
  @record = []

  attr_reader :player, :move, :piece

  def initialize(player)
    @player = player
    puts "#{player.color.to_s.capitalize}'s turn!"
    initiate
    Move.record << move
  end

  def initiate
    @move = player_input
    @piece = square(move[0]).occupied_by

    if evaluate_move.is_a?(Symbol)
      display_move_error(evaluate_move)
      initiate
    end
  end

  def evaluate_move
    return :wrong_color unless players_piece?

    # the piece player has selected is their own piece.
    # the square to land on is unoccupied?
    # there are no pieces in the way if piece doesnt hop
    # if castling then valid castling?
    # if pawn then taking en-passant?
    # move does not put players own king in check
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

  def display_move_error(error)
    case error
    when :wrong_color
      puts "Select a #{player.color.to_s.capitalize} piece to move."
    end
  end
end
