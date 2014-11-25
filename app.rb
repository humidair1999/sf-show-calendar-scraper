require 'sinatra'
require 'nokogiri'
require 'open-uri'

get '/' do
  erb :index
end

get '/test' do
    # doc = Nokogiri::HTML(open("http://www.google.com/"))
    doc = Nokogiri::HTML(open("http://www.google.com")) do |config|
        config.strict.noent
        config.strict.noerror
        config.strict.nonet
    end

    p doc.to_html
end