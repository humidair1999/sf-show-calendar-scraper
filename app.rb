require 'sinatra'
require "sinatra/reloader" if development?
require 'nokogiri'
require 'open-uri'
require 'json'

get '/' do
  erb :index
end

get '/slims' do
    shows = []

    doc = Nokogiri::HTML(open("http://www.slimspresents.com/?sort=#{params[:month]}")) do |config|
        config.strict.noent
        config.strict.noerror
        config.strict.nonet
    end

    doc.at_css("div#content").css("div.today", "div.normal").each do |div|
        if div.at_css('.supporting')
            title = div.at_css('.title').child.text.strip + " " + div.at_css('.supporting').text.strip
        else
            title = div.at_css('.title').child.text.strip
        end

        date = div.at_css('.date').text.strip[2..-3].split[2].to_i

        show_info = {
            :title => title,
            :date => date
        }

        shows << show_info

        p '---------------------------------------------------------'
        p show_info
    end

    content_type :json
    shows.to_json
end

get '/fillmore' do
    month = params[:month].capitalize
    shows = []

    p month

    doc = Nokogiri::HTML(open("http://thefillmore.com/calendar/?m=#{month}")) do |config|
        config.strict.noent
        config.strict.noerror
        config.strict.nonet
    end

    doc.at_css("div.event_data_main").css("div.calendar").each do |div|
        title = div.at_css('.title').child.text.strip

        date_block = div.at_css('.content').child.text.strip
        month_marker = month
        # TODO: make this work for 2015!
        year_marker = "2014"

        date = date_block[/#{month_marker}(.*?)#{year_marker}/m, 1].strip[0..-2].to_i

        show_info = {
            :title => title,
            :date => date
        }

        shows << show_info

        p '---------------------------------------------------------'
        p show_info
    end

    content_type :json
    shows.to_json
end

get '/independent' do
    month = params[:month].capitalize
    shows = []

    p month

    doc = Nokogiri::HTML(open("http://www.theindependentsf.com/calendar/")) do |config|
        config.strict.noent
        config.strict.noerror
        config.strict.nonet
    end

    doc.at_css("div.tfly-calendar").css("table").each do |table|
        if table.css('.month').text.strip == month
            table.css('td.vevent').each do |cell|
                if cell.at_css('.headliners')
                    title = cell.at_css('.headliners').child.text.strip

                    if cell.at_css('.supports')
                        title = title + ' & ' + cell.at_css('.supports').child.text.strip
                    end

                    date = cell.at_css('.date').text.strip.split('/')[1].to_i

                    show_info = {
                        :title => title,
                        :date => date
                    }

                    shows << show_info

                    p '---------------------------------------------------------'
                    p show_info
                end
            end
        else
            p 'incorrect calendar month'
        end
    end

    content_type :json
    shows.to_json
end

get '/warfield' do
    month = params[:month].capitalize[0,3]
    shows = []

    p month

    doc = Nokogiri::HTML(open("http://www.thewarfieldtheatre.com/events")) do |config|
        config.strict.noent
        config.strict.noerror
        config.strict.nonet
    end

    doc.at_css('#eventsList').css('div.entry').each do |div|
        event_date = div.at_css('.date').text.strip
        event_month = event_date.split[1]

        if event_month == month
            date = event_date.split[2][0..-2].to_i

            title = div.at_css('.title').text.strip.split.join(' ')

            show_info = {
                :title => title,
                :date => date
            }

            shows << show_info

            p '---------------------------------------------------------'
            p show_info
        end
    end

    content_type :json
    shows.to_json
end