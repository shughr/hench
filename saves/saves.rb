class Saves < Mustache
  self.template_path = './saves'

  def initialize
    @saves = Dir['./saves/*.toml'].map do |a|
      a.delete_suffix('.toml').delete_prefix('./saves/')
    end
  end

  def characters
    @saves
  end
end
