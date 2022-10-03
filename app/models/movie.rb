class Movie < ActiveRecord::Base
  
  def self.all_ratings
    ['G', 'PG', 'PG-13', 'R']
  end

  def self.with_ratings(ratings_list)
    if ratings_list == nil
      return self.all
    end
    out = self.where(rating: ratings_list.keys)
    if out.present?
      return out
    end
    self.none
  end
end