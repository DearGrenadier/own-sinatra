require 'rack'
require 'pry'

class Cool
  def call(env)
    binding.pry
    http_verb = env['REQUEST_METHOD']
    status = 200
    header = {}
    body = ["got #{http_verb} request\n"]

    [status, header, body]
  end
end

class Middleweare
  def initialize(app)
    @app = app
  end

  def call(env)
    http_verb = env['REQUEST_METHOD']
    if request.patch?
      [405, {}, ['patch not allowed!\n']]
    else
      @app.call(env)
    end
  end
end

app = Rack::Builder do
  use Middleweare
  run Cool.new
end

Rack::Handler::WEBrick.run app, Port: 1488
