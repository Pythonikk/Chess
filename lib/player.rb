# frozen_string_literal: true

# the users
class Player
  include Pieces

  attr_reader :color
  attr_accessor :pieces, :graveyard, :in_check

  def initialize(color)
    @color = color
    set_up_pieces
    @pieces = Pieces.all.select { |piece| piece.color == color }
    @graveyard = []
    @in_check = false
  end

  def piece_taken(piece)
    graveyard << piece
    pieces.reject! { |pi| pi == piece }
  end

  def tokens
    return Pieces::WHITE if color == :white

    Pieces::BLACK
  end

  def king_pos
    king = Pieces.all.select do |piece|
      piece.is_a?(King) &&
        piece.color == color
    end
    king[0].current_pos
  end

  private

  def set_up_pieces
    tokens.each_pair do |type, pos|
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
