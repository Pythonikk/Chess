# frozen_string_literal: true

require 'pry-byebug'

# controls the course of the game
class Game
  class << self
    attr_accessor :mate, :scoresheet, :saved
  end

  @mate = false
  @scoresheet = []
  @saved = false

  attr_reader :board, :player1, :player2
  attr_accessor :player_turn

  def initialize
    select_game
    return if Game.saved

    @player_turn = :white
    @board = Board.new
    @player1 = Player.new(:white)
    @player2 = Player.new(:black)
    Display.instructions
    Display.output
    play
  end

  # serialize all objects
  def self.save
    game = ObjectSpace.each_object(self).to_a[0]
    File.open('./game_save/squares.yaml', 'w') { |fe| fe.write(Board.squares.to_yaml) }
    File.open('./game_save/player1.yaml', 'w') { |fe| fe.write(game.player1.to_yaml) }
    File.open('./game_save/player2.yaml', 'w') { |fe| fe.write(game.player2.to_yaml) }
    File.open('./game_save/scoresheet.yaml', 'w') { |fe| fe.write(scoresheet.to_yaml) }
    File.open('./game_save/mate.yaml', 'w') { |fe| fe.write(mate.to_yaml) }
    File.open('./game_save/player_turn.yaml', 'w') { |fe| fe.write(game.player_turn.to_yaml) }
  end

  private

  def play
    until Game.mate || Game.saved
      if player_turn == :white
        puts "White's turn!"
        Move.new(player1, player2)
        break if Game.saved

        @player_turn = :black
      else
        puts "Black's turn!"
        Move.new(player2, player1)
        break if Game.saved

        @player_turn = :white
      end
      Display.output
    end
  end

  def select_game
    puts Display.select_game
    input = gets.chomp
    return unless input == '1'

    load_game
  end

  def load_game
    Board.squares = YAML.load(File.read('./game_save/squares.yaml'))
    @player1 = YAML.load(File.read('./game_save/player1.yaml'))
    @player2 = YAML.load(File.read('./game_save/player2.yaml'))
    Game.mate = YAML.load(File.read('./game_save/mate.yaml'))
    Game.scoresheet = YAML.load(File.read('./game_save/scoresheet.yaml'))
    @player_turn = YAML.load(File.read('./game_save/player_turn.yaml'))

    Display.instructions
    Display.output
    play
  end
end
