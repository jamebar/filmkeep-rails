module Imports
  class Routine
    cattr_accessor :importers do
      [
        UserImporter,
        FilmImporter,
        RatingTypeImporter,
        ReviewImporter,
        RatingImporter,
        WatchlistImporter,
        ListImporter,
        FilmListImporter,
        CommentImporter,
        FollowerImporter
      ]
    end

    def self.run!
      importers.each { |i| i.process! if i.respond_to?(:process!) }
    end
  end
end