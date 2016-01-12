require './ganja.rb'

get '/hello' do
  "Rocky Balboa #{params.inspect}"
end

post '/post' do
  request.body
end

Rack::Handler::WEBrick.run Rocky::Application
