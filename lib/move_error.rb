# frozen_string_literal: true

# player errors
# to be included in Move class
module MoveError
  def general_error
    { players_piece?: [:wrong_color, player.color.to_s.capitalize],
      valid_movement?: [:invalid_movement, piece.class],
      path_clear?: [:obstructed_path, landing.pos],
      unoccupied_landing?: :occupied_landing }
  end

  def check_error
    if in_check? && puts_in_check?
      :in_check
    elsif puts_in_check?
      :checks_self
    end
  end

  def pawn_error
    if pawn_diagonal? && !pawn_capture?
      :illegal_pawn
    elsif blocked_forward?
      :blocked
    end
  end

  def players_piece?
    @piece.color == @player.color
  end

  def valid_movement?
    piece.moves.any? { |m| m.include?(landing.pos) }
  end

  def path_clear?
    path.each do |pos|
      next if pos == landing.pos

      return false unless square(pos).occupied_by.nil?
    end
    true
  end
end
