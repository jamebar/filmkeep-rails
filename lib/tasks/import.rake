namespace :import do
  task :run => :environment do
    Imports::Routine.run!
  end
end