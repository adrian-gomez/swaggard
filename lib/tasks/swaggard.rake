namespace :swaggard do

  desc 'Clear swaggard cache'
  task :clear_cache => :environment do
    Rails.cache.delete('swagger_doc')
    puts 'Swaggard cache has been cleared'
  end

end