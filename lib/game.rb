# frozen_string_literal: true

require 'pry-byebug'

# controls the course of the game
class Game
  attr_reader

  def initialize
    board = Board.new
    player1 = Player.new(:white)
    player2 = Player.new(:black)
    player1.set_up_pieces
    puts Board.squares.inspect
    puts Board.squares.length
  end

  # display instructions
end
