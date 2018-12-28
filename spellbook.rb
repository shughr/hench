require 'bundler/setup'
require 'mustache'
require 'toml-rb'

# Spell Constructor Class for Unseen Servant App
class Spellbook < Mustache
  attr_accessor :page

  def initialize(page)
    @page = TomlRB.load_file(page)
  end

  def title
    @page['title']
  end

  def type
    @page['type']
  end

  def level
    @page['level']
  end

  def range
    @page['range']
  end

  def duration
    @page['duration']
  end

  def description
    @page['description']
  end
end
