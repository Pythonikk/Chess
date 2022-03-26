# frozen_string_literal: true

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
    Display.select_game
    select_game
    Display.instructions
    Display.output
    play
  end

  def self.save
    save_board
    save_players
    save_score
  end

  private

  def select_game
    return new_game if selection == '0'

    load_game
  end

  def selection
    input = gets.chomp
    return input if %w[0 1].include?(input)

    Display.invalid_selection
    selection
  end

  def new_game
    @player_turn = :white
    @board = Board.new
    @player1 = Player.new(:white)
    @player2 = Player.new(:black)
  end

  def load_game
    load_board
    load_players
    load_score
  end

  def play
    until Game.mate
      case player_turn
      when :white
        white_turn
      else
        black_turn
      end
      Display.output
    end
  end

  def white_turn
    puts "White's turn!"
    Move.new(player1, player2)
    @player_turn = :black
  end

  def black_turn
    puts "Black's turn!"
    Move.new(player2, player1)
    @player_turn = :white
  end

  def load_board
    Board.squares = YAML.load(File.read('./game_save/squares.yaml'))
  end

  def load_players
    @player1 = YAML.load(File.read('./game_save/player1.yaml'))
    @player2 = YAML.load(File.read('./game_save/player2.yaml'))
    @player_turn = YAML.load(File.read('./game_save/player_turn.yaml'))
  end

  def load_score
    Game.scoresheet = YAML.load(File.read('./game_save/scoresheet.yaml'))
    Game.mate = YAML.load(File.read('./game_save/mate.yaml'))
  end

  class << self
    private

    def save_board
      File.open('./game_save/squares.yaml', 'w') { |fe| fe.write(Board.squares.to_yaml) }
    end

    def save_players
      game = ObjectSpace.each_object(self).to_a[0]
      File.open('./game_save/player1.yaml', 'w') { |fe| fe.write(game.player1.to_yaml) }
      File.open('./game_save/player2.yaml', 'w') { |fe| fe.write(game.player2.to_yaml) }
      File.open('./game_save/player_turn.yaml', 'w') { |fe| fe.write(game.player_turn.to_yaml) }
    end

    def save_score
      File.open('./game_save/scoresheet.yaml', 'w') { |fe| fe.write(scoresheet.to_yaml) }
      File.open('./game_save/mate.yaml', 'w') { |fe| fe.write(mate.to_yaml) }
    end
  end
end
