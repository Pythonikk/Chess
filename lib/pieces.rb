# frozen_string_literal: true

# the pieces in the game
module Pieces
  class << self
    attr_accessor :all
  end

  @all = []

  WHITE = { rook: %i[a1 h1], knight: %i[b1 g1], bishop: %i[c1 f1], queen: :d1,
            king: :e1, pawn: %i[a2 b2 c2 d2 e2 f2 g2 h2] }.freeze

  BLACK = { rook: %i[a8 h8], knight: %i[b8 g8], bishop: %i[c8 f8], queen: :d8,
            king: :e8, pawn: %i[a7 b7 c7 d7 e7 f7 g7 h7] }.freeze

  SYMBOL = { king: "\u{265A}", queen: "\u{265B}", rook: "\u{265C}",
             bishop: "\u{265D}", knight: "\u{265E}", pawn: "\u{265F}" }.freeze

  def self.give_character(type, color, pos)
    klass = Object.const_get(type.to_s.capitalize)
    piece = klass.new(type, color, pos)
    Pieces.settle_in(piece)
    Pieces.all << piece
  end

  def self.settle_in(piece)
    square = Board.squares.select { |s| s.position == piece.current_pos }[0]
    square.occupied_by = piece
  end
end
