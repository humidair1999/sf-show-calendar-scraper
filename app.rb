require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'json'

get '/' do
  erb :index
end

get '/test' do
    shows = []

    # doc = Nokogiri::HTML(open("http://www.google.com/"))
    doc = Nokogiri::HTML(open("http://www.slimspresents.com/?sort=#{params[:month]}")) do |config|
        config.strict.noent
        config.strict.noerror
        config.strict.nonet
    end

    doc.at_css("div#content").css("div.normal").each do |div|
        if div.at_css('.supporting')
            title = div.at_css('.title').child.text.strip + " " + div.at_css('.supporting').text.strip
        else
            title = div.at_css('.title').child.text.strip
        end

        show_info = {
            :title => title,
            :date => div.at_css('.date').text.strip
        }

        shows << show_info

        p '---------------------------------------------------------'
        p show_info
    end

    content_type :json
    shows.to_json
end