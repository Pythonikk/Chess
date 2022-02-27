# frozen_string_literal: true

# the users
class Player
  include Pieces

  attr_reader :color
  attr_accessor :graveyard

  def initialize(color)
    @color = color
    @graveyard = []
  end

  def pieces
    return Pieces::WHITE if color == :white

    Pieces::BLACK
  end

  def set_up_pieces
    pieces.each_pair do |type, pos|
      if pos.is_a?(Array)
        pos.each do |po|
          Pieces.give_character(type, color, po)
        end
      else
        Pieces.give_character(type, color, pos)
      end
    end
  end
end
