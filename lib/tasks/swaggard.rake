namespace :swaggard do

  desc 'Clear swaggard cache'
  task :clear_cache => :environment do
    Rails.cache.delete('swaggard_doc_json')
    puts 'Swaggard cache has been cleared'
  end

end