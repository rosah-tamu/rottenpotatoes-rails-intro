class Movie < ActiveRecord::Base


    def self.with_ratings(ratings)
        if ratings.empty?
            return Movie.all
        end
        return Movie.where(rating: ratings)
    end
    
    def self.list_all_values_of_column(column)
        return Movie.uniq.pluck(column)
    end    
end    