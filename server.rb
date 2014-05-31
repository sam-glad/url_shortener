require 'sinatra'
require 'pg'
require 'pry'

def load_urls
  connection = PG.connect(dbname: 'urls')
  urls = connection.exec('SELECT urls.site_name, urls.shortened, urls.url
                          FROM urls')
  connection.close

  urls.to_a
end

def make_site_name(url)
  url.slice!("https://")
  url.slice!("http://")
  url.slice!("www.")
  url = url.split("/").first.capitalize!
end

def post_url(url, shrunken)
  site_name = make_site_name(url)
  sql = 'INSERT INTO urls (url, site_name, shortened) VALUES ($1, $2, $3)'

  connection = PG.connect(dbname: 'urls')
  connection.exec_params(sql, [url, site_name, shrunken])
  connection.close
end

def locate_url(page_id) # TODO rename this
  connection = PG.connect(dbname: 'urls')
  url_shortened = connection.exec("SELECT urls.url
                                   FROM urls WHERE urls.shortened = '#{page_id}'")
  connection.close

  url_shortened.to_a
end

get '/' do
  @title = "URL Sh0rt3n0rz"
  @page_title = @title
  @urls = load_urls
  erb :index
end

post '/' do
  @shrunken = rand(1..1000).to_s # TODO method; check for existing number
  post_url(params["url"], @shrunken)
  redirect '/'
end

get '/:url_num' do # url_num being the @shrunken in the above "post" block
  @page_id = params[:url_num]
  @urls = load_urls
  @redir = locate_url(@page_id)
  redirect "http://#{@redir.first["url"]}"
end
