require_relative 'spellbook'
require_relative 'index'
require_relative 'sheet'
require_relative 'saves/saves'

# Top-level class for Hench App
class Hench
  def call(env)
    req = Rack::Request.new(env)
    case req.path
    when '/'
      index = Index.new
      ['200', { 'Content-Type' => 'text/html' }, [index.render]]
    when '/spellbook'
      q = req.params
      s = Spellbook.new("./spells/#{q['book']}/#{q['spell']}")
      ['200', { 'Content-Type' => 'text/html' }, [s.render]]
    when '/character/new'
      q = req.params
      c = Character.new(q['name'], q['role'])
      c.save
      s = Sheet.new(c)
      ['200', { 'Content-Type' => 'text/html' }, [s.render]]
    when '/character/load'
      q = req.params
      c = Character.load(q['file'])
      s = Sheet.new(c)
      ['200', { 'Content-Type' => 'text/html' }, [s.render]]
    when '/character/list'
      list = Saves.new
      ['200', { 'Content-Type' => 'text/html' }, [list.render]]
    else
      ['404', { 'Content-Type' => 'text/html' }, ['404 Not Found']]
    end
  end
end
