# frozen_string_literal: true

# an individual square on the board (the nodes)
class Square
  attr_reader :position, :color, :occupied

  def initialize(position, color)
    @position = position
    @color = color
    @occupied = false
  end

  def occupied?; end
end
