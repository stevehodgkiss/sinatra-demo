require 'sinatra/base'
require 'sinatra_warden'
require 'rack/flash'

require 'app/warden'
require 'app/user'
require 'slim'

module Sinatra
  module Templates
    def slim(template, options={}, locals={})
      render :slim, template, options, locals
    end
  end
end

class App < Sinatra::Base
  # Hack so that sinatra-warden uses slim
  def haml(*options)
    slim(*options)
  end
  
  set :app_file, __FILE__

  enable :sessions
  use Rack::Flash
  use Rack::Session::Cookie

  use Warden::Manager do |manager|
    manager.default_strategies :password
    manager.failure_app = App
  end
  
  register Sinatra::Warden
  set :auth_failure_path, '/login'

  get "/" do
    slim :welcome
  end
end
