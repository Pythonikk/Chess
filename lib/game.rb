# frozen_string_literal: true

require 'pry-byebug'

# controls the course of the game
class Game
  class << self
    attr_accessor :mate, :stalemate
  end

  @mate = false

  attr_reader :board, :player1, :player2

  def initialize
    @board = Board.new
    @player1 = Player.new(:white)
    @player2 = Player.new(:black)
    Display.instructions
    Display.output
    play
  end

  def play
    until Game.mate
      Move.new(player1, player2)
      Display.output
      break if Game.mate

      Move.new(player2, player1)
      Display.output
    end
  end
end
