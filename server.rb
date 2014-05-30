require 'sinatra'
require 'pg'

def load_urls
  connection = PG.connect(dbname: 'urls')
  urls = connection.exec('SELECT urls.site_name, urls.shortened, urls.url
                          FROM urls')
  connection.close

  urls
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

get '/' do
  @title = "URL Sh0rt3n0rz"
  @page_title = @title
  @urls = load_urls

  erb :index
end

post '/' do
  @shrunken = rand(1..1000).to_s
  post_url(params["url"], @shrunken)
  redirect '/'
end

get '/:shrunken' do
  @urls = load_urls
  @page_id = params["shrunken"]
  @urls.each do |url|
    if url["shortened"] == @page_id
      redirect "http://#{url["url"]}"
    end
  end
end

  # @urls = load_urls
  # @page_id = params["shortened"]
  # @urls.each do |url|
  #   if url["shortened"] == @page_id
  #     redirect @page_id
  #   end
  # end

# end

  # @urls.each do |url|
  #   if url["url"] == @potato

  #   end
  # end

  # @redir = "http://#{@urls["url"]}"
  # @urls.each do |url|
  #   if url["shortened"] == @potato
  #     redirect @redir
  #   end
  # end
# end
