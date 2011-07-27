class User < ActiveRecord::Base
  has_one :stats

  #def stats
  #  
  #end

  acts_as_authentic #do |c|
    #options
    #c.logged_in_timeout = 30.minutes
  #end
end
