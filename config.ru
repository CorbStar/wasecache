require 'appengine-rack'
require 'word'



AppEngine::Rack.configure_app(
    :application => '',
    :precompilation_enabled => true,
    :version => 1)

if(methods.member?("to_xml"))
map '/admin' do
    use AppEngine::Rack::AdminRequired 
end 
end

run Sinatra::Application
