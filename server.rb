require 'sinatra'
require 'csv'


def read_articles_from(filename)
  articles = []

  CSV.foreach(filename, headers: true) do |row|
    articles << {
      title: row['title'],
      description: row['description'],
      url: row['url']
    }
  end
  articles
end

def save_article(filename, title, description, url)
  CSV.open(filename, 'a') do |csv|
    csv << [title, description, url]
  end
end


get '/' do
  erb :index
end

get '/article' do
  @articles = read_articles_from('article.csv')
  erb :article
end

get '/article/submit' do
  erb :submit
end

post '/article/submit' do
  @title = params[:article][:title]
  @description = params[:article][:description]
  @url = params[:article][:url]
  save_article('article.csv', @title, @description, @url)
  redirect '/article'
end
