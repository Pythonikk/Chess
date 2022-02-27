# frozen_string_literal: true

# an individual square on the board (the nodes)
class Square
  attr_reader :position, :color
  attr_accessor :occupied_by

  def initialize(position, color)
    @position = position
    @color = color
    @occupied_by = nil
  end

  def occupied?
    Pieces.all.collect(&:current_pos).include?(position)
  end
end
