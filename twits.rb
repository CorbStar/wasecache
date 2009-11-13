
require 'yaml'
require 'json/pure'
require 'appengine-apis/urlfetch'
Net::HTTP = AppEngine::URLFetch::HTTP
Url = AppEngine::URLFetch

class Twits
  
  def initialize
    yaml = YAML.load_file('admin/login.yaml')
    @user = yaml["name"]
    @pass = yaml["password"]
    @r_name = "@#{@user}"
  end
  
  def location(id)
    url = 'http://twitter.com/users/'+id+'.json'
    req = Net::HTTP::Get.new(url)
    req.basic_auth(@user,@pass)
    res = request(url,req)
    if(res.code == "200")
      j = JSON.parse(res.body)
      return j["location"]
    end
    "nope"
  end
  
  def f_status
    
  end
  
  def legit?(message)
    info, counter, program_list, timestamp, output, input_1, input_2 = message.split(/,/)
    if(info.include?(@r_name) && info.include?("#wase"))
      return true
    end
    return false
  end
  
  def mentions
    url = 'http://twitter.com/statuses/mentions.json'
    req = Net::HTTP::Get.new(url)
    req.basic_auth(@user,@pass)
    request(url,req)
  end
  
  def request(url,req,body=nil)
    begin
      options = {
        :payload => body,
        :follow_redirects => false,
        :allow_truncated => true,
        :method => req.method,
        :headers => req
           }
      return Url.fetch(url,options)
    end
  end
  
  def update(text)
    url = 'http://twitter.com/statuses/update.json'
    req = Net::HTTP::Post.new(url)
    req.basic_auth(@user,@pass)
    body =  "status=#{text}"
    request(url,req,body)
  end
  
end

class Bits
  
  def initialize
    yaml = YAML.load_file('admin/bitly.yaml')
    @user = yaml["name"]
    @key = yaml["key"]
    
  end
  
  def expand(addr)
    address = 'http://api.bit.ly/expand?version=2.0.1&shortUrl='+
	"#{'http://'+addr}&login=#{@user}&apiKey=#{@key}"
    f  = Url.fetch(address)
    if(f.code=="200")
      j = JSON.parse(f.body)
      result = j["results"]
      return result[result.keys.first]["longUrl"] unless result.nil?
    end
  end

end