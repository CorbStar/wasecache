
require 'sinatra'
require 'dm-core'
require 'twits.rb'
DataMapper.setup(:default, "appengine://auto")

#Models
class Tweeter
  include DataMapper::Resource
  
  property :id, Serial
  property :twit_id, ByteString
  property :location, ByteString
end

class Hashes
  include DataMapper::Resource
  
  property :id, Serial
  property :hash, Blob
end

# Make sure our template can use <%=h
helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get '/' do
  # Just list all the shouts
  @shouts = Tweeter.all
  erb :index
end

get '/getlocation' do
  twits = Twits.new
  loc = params[:id]
  temp = twits.location(loc)
  if(!temp.nil? && temp != "nope")
    Tweeter.create(:twit_id => params[:id],:location => temp)
    return temp
  else
    "Error Getting Location"
  end
end
  
get '/admin/mentions' do
  twit = Twits.new
  mens = twit.mentions
  if(mens.code=="200")
    JSON.parse(mens.body).each do |mention|
      puts "#{twit.legit?(mention["text"])}\t#{mention["text"]}"
    end
  end
end

post '/' do
  # Create a new shout and redirect back to the list.
  shout = Shout.create(:message => params[:message])
  redirect '/'
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
