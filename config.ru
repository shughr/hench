require_relative 'hench'

use Rack::Static, :urls => ['/css'], :root => 'public'

run Hench.new
