require_relative 'character'

class Sheet < Mustache
  def initialize(character = Character.new)
    @character = character
  end

  def bio
    @character.bio
  end

  def abilities
    @character.abs
  end

  def skills
    @character.skl
  end

  def spells
    return false unless bio[:role] == 'Magic-user'

    @character.mag.map { |s| s['title'] }
  end
end
