require 'rubygems'
require 'twilio-ruby'

namespace :sports do

desc "Show game times for all users following mlb"
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



  @user_array.each do |user|
    @mlbteams.each_pair do|key,value|
      if value.first == user.team

        #create message by appending data. this is because the body: section below in the twilio code will only accept
        # one data type
        user.message = 'Hi '
        user.message << user.email
        user.message << '! '
        user.message << user.team
        user.message << ' plays at '
        user.message << value.last

        client = Twilio::REST::Client.new 'ACc37abcdd6d04384260291eb1f7075584', '8ef5aec33725886af6b1f9981bf86c0e'
        #client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
        message = client.messages.create from: '15102300477', to: user.phone, body: user.message

        print "\n#{user.team} play at #{value.last}\n"

      else
          if value.second == user.team

            user.message = 'Hi '
            user.message << user.email
            user.message << '! '
            user.message << user.team
            user.message << ' plays at '
            user.message << value.last

            client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
            message = client.messages.create from: '15102300477', to: user.phone, body: user.team

            print "\n#{user.team} play at #{value.last}\n"
          end
      end
    end
  end




end

end