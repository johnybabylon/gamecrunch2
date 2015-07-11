require 'open-uri'
require 'nokogiri'
require 'rubygems'


namespace :sports do

  desc 'scrapes web for mlb schedule'
  task webscrape: :environment do            #scrapes web for MLB schedule

    page = Nokogiri::HTML(open("http://sports.yahoo.com/mlb/scoreboard/"))


    mlbteams = Hash.new{|teams, key| teams[key] = []}

    #mlbteams = Array.new

    @mlbteams = mlbteams

    key = 0
    value = 0
    #page.css('tr.home.team') - allows you to pick two word classes!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    #page.css('div.wisfb_fullTeamStacked span').each do |node|  - old code


    page.css('em').each do |node|           #scrape for teams

      @mlbteams[key] << node.text
      #@mlbteams[key].push({node.text}) - old code

      value += 1

      if value.even?
        #if value % 6 == 0 - old
        key +=1
        #@mlbteams[key] = 1 - old
      end
    end

    key = 0 #reset key and value to start back at beginning of hash and push time onto the stack
    value = 0

    page.css('span.meta').each do |node|        #the first css is ('span.time') ---this scrapes time
      @mlbteams[key] << node.text        # I tried to use the code below, but when I set up the hash nested hash
      key +=1                        # it wouldn't let me get my nested hash value with a key; I had to use .last
    end                  # method.  So I decided to just use THIS code here to my left and in the hash use .last method
    # to get the time.  I can use span.meta  OR span.time




    #set the model
    @mlb = Mlb.find(1)

    #clear previous schedule
    @mlb.team.clear
    @mlb.save

    #update new schedule
    @mlb.team = @mlbteams
    @mlb.save


  end

end