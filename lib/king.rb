# frozen_string_literal: true

# defines the kings behavior
class King
  attr_reader :type, :color, :start_pos, :current_pos

  def initialize(type, color, pos)
    @type = type
    @color = color
    @pos = pos
    @current_pos = pos
  end

  # current_pos looks like :b2
  def moves
    arr = []
    cp1 = current_pos[0]
    cp2 = current_pos[1].to_i

    north_row = Board.column(cp1, 1)
    south_row = Board.column(cp1, -1)

    columns = [cp2 - 1, cp2, cp2 + 1]

    columns.each do |col|
      arr << [north_row, col]
      arr << [cp1, col]
      arr << [south_row, col]
    end

    arr.map! { |i| i.join('').to_sym }
       .reject! { |i| i == current_pos }
  end
end
