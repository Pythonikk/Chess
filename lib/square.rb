# frozen_string_literal: true

# an individual square on the board (the nodes)
class Square
  attr_reader :pos, :color
  attr_accessor :occupied_by

  def initialize(pos, color)
    @pos = pos
    @color = color
    @occupied_by = nil
  end

  def occupied?
    return true unless occupied_by.nil?

    false
  end

  def update(piece = nil)
    self.occupied_by = piece
  end

  def self.find_by_pos(position)
    square = Board.squares.select { |s| s.pos == position }[0]
    return square if square

    puts 'An invalid square was entered'
  end

  def self.find_by_occupant(occupant)
    Board.squares.select { |s| s.occupied_by == occupant }[0]
  end
end
