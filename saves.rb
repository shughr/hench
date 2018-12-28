module Bonus
  BONUS = {
    3 => -3, 4..5 => -2, 6..8 => -1, 9..12 => 0, 13..15 => 1, 16..17 => 2, 18 => 3
  }.freeze
end

module Roles
  ROLES = [
    'Fighter', 'Magic-User', 'Specialist', 'Cleric'
  ].freeze
end
