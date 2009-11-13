
require 'sinatra'
require 'twits.rb'



helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end




  
get '/admin/mentions' do
  twit = Twits.new
  mens = twit.mentions
  if(mens.code=="200")
    JSON.parse(mens.body).each do |mention|
      
    end
  end
end





__END__

@@ index
<html>
  <head>
    <title>Shoutout!</title>
  </head>
  <body style="font-family: sans-serif;">
    <h1>Shoutout!</h1>

    

    <% @shouts.each do |shout| %>
    <p>Someone wrote, <q><%=h shout.location %></q></p>
    <% end %>

    <div style="position: absolute; bottom: 20px; right: 20px;">
    <img src="/images/appengine.gif"></div>
  </body>
</html>
