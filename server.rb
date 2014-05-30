require 'sinatra'
require 'pg'

def load_urls
  connection = PG.connect(dbname: 'urls')
  urls = connection.exec('QUERY GOES HERE!')
  connection.close

  urls
end

get '/' do
  @title = "URL Sh0rt3n0rz"
  @page_title = @title
  @urls = load_urls
  erb :index
end

get '/new-url' do

end
