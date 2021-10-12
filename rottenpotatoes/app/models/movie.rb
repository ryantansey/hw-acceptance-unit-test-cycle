class Movie < ActiveRecord::Base
    def self.find_same_director director
        Movie.where(:director => director)
    end
end
