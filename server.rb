# server.rb
# TODO: add about page (erb file + content)
# TODO: automatically delete all links > 6 months old from database

require 'sinatra'
require 'pg'
require 'pry'
require './helper_methods.rb'

get '/' do
  @title = 'SaZa'
  @page_title = @title
  @urls = load_urls
  @count = @urls.length
  erb :index
end

post '/' do
  @shrunken = assign_short_url
  post_url(params['url'], @shrunken)
  redirect '/'
end

get '/:url_num' do # url_num being the @shrunken in the above "post" block
  @page_id = params[:url_num]
  @redir = locate_url(@page_id)
  redirect "http://#{@redir.first['url']}"
end

get '/about' do
  'Under construction...'
  erb :about
end
