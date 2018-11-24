require 'mustache'
require 'tomlrb'

path = "./data/characters/Bort.toml"
c = Tomlrb.load_file(path, symbolize_keys: true)

bio = c[:bio]
abs = c[:ability_scores]
sav = c[:saving_throws]
skl = c[:skills]
spl = c[:spells]
pra = c[:prayers]
cmb = c[:combat]
eqp = c[:equipment]

class CharacterSheet < Mustache
end

sheet = CharacterSheet.render(title: bio[:name], player: bio[:player])

print sheet 