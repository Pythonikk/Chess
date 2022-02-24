# frozen_string_literal: true

# the users
class Player
  attr_reader :color

  def initialize(color)
    @color = color
    @graveyard = []
  end

  def pieces
    return Piece::WHITE if color == :white

    Piece::BLACK
  end

  def set_up_pieces
    pieces.each_pair do |type, pos|
      if pos.is_a?(Array)
        pos.each do |po|
          Piece.new(type, color, po)
        end
      else
        Piece.new(type, color, pos)
      end
    end
  end
end
