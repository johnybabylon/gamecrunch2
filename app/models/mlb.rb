class Mlb < ActiveRecord::Base
  serialize :team, Hash
end
