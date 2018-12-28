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
end
