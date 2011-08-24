class User < ActiveRecord::Base
  has_one :stats

  
  acts_as_authentic  do |c|
    c.logged_in_timeout = 5.minutes
    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
   end
  
  def games(limit=-1, desc=true)
    if stats and not limit == 0
      direction = desc ? 'DESC' : 'ASC'
      stats.games.all(:limit => limit, :order => "games.id #{direction}")
    end
  end

  def rounds(limit=-1, desc=true)
    if stats and not limit == 0
      all_rounds = []
      direction = desc ? 'DESC' : 'ASC'

      stats.games.all(:order => "games.id #{direction}").each do |game|
        new_rounds = game.rounds.all(:limit => limit,
                                     :order => "rounds.id #{direction}")
        all_rounds << new_rounds
        limit -= new_rounds.size
        if limit <= 0
          break
        end
      end
      all_rounds.flatten
    end
  end

  def games_won(desc=true)
    direction = desc ? 'DESC' : 'ASC'
    stats.games.find_all_by_winner(stats, :order => "games.id #{direction}")
  end

  def games_lost(desc=true)
    direction = desc ? 'DESC' : 'ASC'
    stats.games.order("games.id #{direction}").where("winner != ?", stats) 
  end

  def to_s
      username
  end

end
