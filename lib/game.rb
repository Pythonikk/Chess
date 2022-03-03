# frozen_string_literal: true

require 'pry-byebug'

# controls the course of the game
class Game
  class << self
    attr_accessor :mate, :stalemate
  end

  @mate = false
  @stalemate = false

  attr_reader :board, :player1, :player2

  def initialize
    @board = Board.new
    @player1 = Player.new(:white)
    @player2 = Player.new(:black)
    Display.output
    play
  end

  def play
    # until game_over?
    loop do
      Move.new(player1, player2)
      Display.output
      break if Game.mate || Game.stalemate

      Move.new(player2, player1)
      Display.output
      break if Game.mate || Game.stalemate
    end
  end
end
