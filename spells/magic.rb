require 'toml-rb.rb'

# Instantiates a hash containing hash representations of the spell pages in
# spells/cleric and spells/magic-user
class Magic
  attr_accessor :spells, :level_one
  def initialize
    mu_toc = Dir['./spells/magic-user/*']
    cl_toc = Dir['./spells/cleric/*']
    @spells = { mu: [], cl: [] }
    @level_one = { mu: [], cl: [] }
    mu_toc.each { |f| spells[:mu].push(TomlRB.load_file(f)) }
    cl_toc.each { |f| spells[:cl].push(TomlRB.load_file(f)) }
    spells[:mu].each { |spell| level_one?(spell, :mu) }
    spells[:cl].each { |spell| level_one?(spell, :cl) }
  end

  def level_one?(spell, type)
    return false if spell['title'] == '' || spell['title'] == 'Read Magic'

    @level_one[type].push(spell) if spell['level'] == 1
  end
end
