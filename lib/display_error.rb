# frozen_string_literal: true

# player errors to be printed in terminal
# to extend Display class
module DisplayError
  def wrong_color(player_color)
    "=> Select a #{player_color} piece to move."
  end

  def occupied_landing
    "=> You already occupy the square you're trying to move to."
  end

  def obstructed_path(end_position)
    "=> The path to #{end_position} is obstructed."
  end

  def invalid_movement(piece_class)
    "=> Might be time to review how a #{piece_class} moves."
  end

  def illegal_pawn
    '=> Your pawn cannot move diagonally without capturing.'
  end

  def in_check
    '=> Your King is in check. You must move or guard him.'
  end

  def checks_self
    '=> That move is illegal, it puts your King in check.'
  end

  def blocked
    '=> Your pawn is blocked.'
  end
end
