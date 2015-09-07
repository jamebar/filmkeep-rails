namespace :import do
  task :run => :environment do
    abort("Please disable streamrails before running imports") if StreamRails.config.enabled
    Imports::Routine.run!
  end
end