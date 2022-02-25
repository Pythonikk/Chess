# frozen_string_literal: true

# defines the Pawns behavior
class Pawn
  attr_reader :type, :color, :start_pos, :current_pos,
              :cp1, :cp2, :squares

  def initialize(type, color, pos)
    @type = type
    @color = color
    @pos = pos
    @current_pos = pos
    abbreviate
  end

  def abbreviate
    @cp1 = current_pos[0]
    @cp2 = current_pos[1].to_i
  end

  def moves
    @squares = []
    starting_move
    forward_move
    format_squares
  end

  def starting_move
    squares << [cp1, cp2 + 2]
  end

  def forward_move
    squares << [cp1, cp2 + 1]
  end

  # can move diagonally to capture
  def capture_moves
    right_column = Board.column(cp1, 1)
    left_column = Board.column(cp1, -1)

    [[right_column, cp2 + 1], [left_column, cp2 + 1]]
  end

  def format_squares
    squares.map! { |i| i.join('').to_sym }
  end
end
