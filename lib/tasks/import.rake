namespace :import do
  task :run => :environment do
    StreamRails.enabled = false
    abort("Please disable streamrails before running imports") if StreamRails.config.enabled
    Imports::Routine.run!
    StreamRails.enabled = true
  end
end