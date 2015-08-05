require 'open-uri'
require 'nokogiri'
require 'rubygems'




  desc 'scrapes web for mlb schedule'
  task mlbscrape: :environment do            #scrapes web for MLB schedule

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



task mlb_compare: :environment do

  TWILIO_ACCOUNT_SID='ACc37abcdd6d04384260291eb1f7075584'
  TWILIO_AUTH_TOKEN='8ef5aec33725886af6b1f9981bf86c0e'


# finds all where user.team = 'mlb' & assigns to var
  @users = User.all
  @user_array = @users.where(:league => 'mlb')

  print "\nUsers following MLB:\n"

  @user_array.each do |user|
    print "#{user.email}\n"
  end



#set up hash to recieve hash schedule from mlb.team model

  mlbteams = Hash.new{|teams, key| teams[key] = []}

  @mlbteams = mlbteams
  @user_team = ""

# assign it db info
  @mlbteams = Mlb.find(1).team  #get Mlb.team schedule from model, assign to var

# get model to hold users whose teams play today

  @user_array.each do |user|
    @mlbteams.each_pair do|key,value|
      if value.first == user.team

        #create message by appending data. this is because the body: section below in the twilio code will only accept
        # one data type
        user.message = 'Hi '
        user.message << user.email
        user.message << '! '
        user.message << user.team
        user.message << ' plays today @ '
        user.message << value.last

        client = Twilio::REST::Client.new 'ACc37abcdd6d04384260291eb1f7075584', '8ef5aec33725886af6b1f9981bf86c0e'
        #client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
        message = client.messages.create from: '14159172576', to: user.phone, body: user.message

        print "\n#{user.team} plays at #{value.last}\n"


      else
        if value.second == user.team


          user.message = 'Hi '
          user.message << user.email
          user.message << '! '
          user.message << user.team
          user.message << ' plays at today '
          user.message << value.last

          client = Twilio::REST::Client.new 'ACc37abcdd6d04384260291eb1f7075584', '8ef5aec33725886af6b1f9981bf86c0e'
          #client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
          message = client.messages.create from: '14159172576', to: user.phone, body: user.message

          print "\n#{user.team} play at #{value.last}\n"

          @today = user

        end
      end
    end
  end
end



