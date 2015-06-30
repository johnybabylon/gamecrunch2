
namespace :sports do

desc "Show game times for all users following mlb"
task mlb_compare: :environment do
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
        print "\n#{user.team} play at #{value.last}\n"
      else
          if value.second == user.team
            print "\n#{user.team} play at #{value.last}\n"
          end
      end
    end
  end




end

end