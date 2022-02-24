# frozen_string_literal: true

# the pieces in the game
class Piece
  class << self
    attr_accessor :all
  end

  @all = []

  attr_reader :type, :color, :start_pos
  attr_accessor :current_pos

  def initialize(type, color, start_pos)
    @type = type
    @color = color
    @start_pos = start_pos
    @current_pos = start_pos
    settle_in
    Piece.all << self
  end

  def settle_in
    square = Board.squares.select { |s| s.position == current_pos }[0]
    square.occupied_by = self
  end

  WHITE = { rook: [:a1, :h1], knight: [:b1, :g1], bishop: [:c1, :f1], queen: :d1,
            king: :e1, pawn: [:a2, :b2, :c2, :d2, :e2, :f2, :g2, :h2] }.freeze

  BLACK = { rook: [:a8, :h8], knight: [:b8, :g8], bishop: [:c8, :f8], queen: :d8,
            king: :e8, pawn: %i[a7 b7 c7 d7 e7 f7 g7 h7] }.freeze
end
