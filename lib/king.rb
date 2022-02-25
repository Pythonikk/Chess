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

    right_column = Board.column(cp1, 1)
    left_column = Board.column(cp1, -1)

    rows = [cp2 - 1, cp2, cp2 + 1]

    rows.each do |row|
      arr << [right_column, row]
      arr << [cp1, row]
      arr << [left_column, row]
    end

    arr.map! { |i| i.join('').to_sym }
       .reject! { |i| i == current_pos }
  end
end
