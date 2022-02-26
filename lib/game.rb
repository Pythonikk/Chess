# frozen_string_literal: true

require 'pry-byebug'

# controls the course of the game
class Game
  attr_reader :board, :player1, :player2

  def initialize
    @board = Board.new
    @player1 = Player.new(:white)
    @player2 = Player.new(:black)
    player1.set_up_pieces
    player2.set_up_pieces
    board.display
  end

  def play
    # until game_over?
    Move.new(player1)
    Move.new(player2)
  end

  def game_over?
    mate? || stalemate?
  end

  def mate?; end

  def stalemate; end
end
