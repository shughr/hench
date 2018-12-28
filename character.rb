require 'mustache'
require 'toml-rb'

includes 'saves'

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
    @abs[:bonus] = BONUS.select { |k| k === @abs[:score] }.values.first
  end
end

# Class construct for playable characters, including bio, ability, and skills
class Character
  attr_accessor :bio, :abs, :skl
  def initialize(name = '', role = '')
    instance_variable_set(:@bio,
                          name: name, role: role.capitalize, level: 1)
    instance_variable_set(:@abs,
                          str: Ability.new.abs,
                          dex: Ability.new.abs,
                          con: Ability.new.abs,
                          int: Ability.new.abs,
                          wis: Ability.new.abs,
                          cha: Ability.new.abs)
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
