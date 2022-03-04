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
end
