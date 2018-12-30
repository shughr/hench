require 'mustache'
require 'toml-rb'
require_relative 'spells/magic'

BONUS = {
  0..3 => -3,
  4..5 => -2,
  6..8 => -1,
  9..12 => 0,
  13..15 => 1,
  16..17 => 2,
  18..-1 => 3
}.freeze

ROLES = %w[
  Fighter Magic-user Specialist Cleric
].freeze

SKILLS = %i[
  architecture bushcraft climb
  languages search sleight_of_hand
  sneak_attack stealth tinker
].freeze

# Class construct for playable characters, including bio, ability, and skills
class Character
  attr_accessor :bio, :abs, :skl, :mag
  def initialize(name = '', role = '')
    new_bio(name, role)
    new_abilities
    new_skills
    case @bio[:role]
    when 'Magic-user'
      new_magic(:mu)
    when 'Cleric'
      new_magic(:cl)
    end
  end

  def new_bio(name, role)
    instance_variable_set(:@bio,
                          name: name,
                          role: role.capitalize,
                          level: 1)
  end

  def new_abilities
    instance_variable_set(:@abs,
                          str: Ability.new.abs,
                          dex: Ability.new.abs,
                          con: Ability.new.abs,
                          int: Ability.new.abs,
                          wis: Ability.new.abs,
                          cha: Ability.new.abs)
  end

  def new_skills
    instance_variable_set(:@skl,
                          architecture: 1,
                          bushcraft: 1,
                          climb: 1,
                          languages: 1,
                          search: 1,
                          sleight_of_hand: 1,
                          sneak_attack: 1,
                          stealth: 1,
                          tinker: 1)
    return false unless @bio[:role] == 'Specialist'

    4.times { @skl[SKILLS[Dice.roll(1, 9)]] += 1 }
  end

  def new_magic(type)
    instance_variable_set(:@mag, [])
    magic = Magic.new
    case type
    when :mu
      3.times do
        spell = magic.level_one[type][Dice.roll(1, 20)]
        redo if @mag.include?(spell)
        @mag.push(spell)
      end
      @mag.push(magic.spells[:mu].select { |h| h['title'] == 'Read Magic' }.pop)
    when :cl
      @mag = magic.spells[:cl]
    end
  end

  def save
    save = {}
    instance_variables.each do |var|
      save[var[1..-1].to_sym] = instance_variable_get(var)
    end
    toml = TomlRB.dump(save)
    file = File.new("saves/#{@bio[:name]} the #{@bio[:role]}.toml", 'w')
    File.write(file, toml)
  end

  def self.load(file)
    hash = TomlRB.load_file(file, symbolize_keys: true)
    cha = Character.new
    hash.keys.each do |key|
      var = key.to_s.insert(0, '@').to_sym
      cha.instance_variable_set(var, hash[key])
    end
    cha
  end
end

# Class constructor for generating random numbers according to die size
class Dice
  attr_accessor :result
  def initialize(sides = 6)
    @result = Random.new.rand(1..sides)
  end

  def self.roll(num, sides)
    results = []
    Range.new(1, num).step do
      d = Dice.new(sides)
      results.push(d.result)
    end
    results.sum
  end
end

# Class constructor for character ability scores and bonuses
class Ability
  attr_accessor :abs
  def initialize
    @abs = {}
    @abs[:score] = Dice.roll(3, 6)
    @abs[:bonus] = BONUS.select { |k| k.cover?(@abs[:score]) }.values.first
  end
end
