namespace :swaggard do

  desc 'Clear swaggard cache'
  task :clear_cache => :environment do
    Rails.cache.delete('swaggard_doc_json')
    puts 'Swaggard cache has been cleared'
  end

  desc 'Dump swagger.json'
  task :dump => :environment do
    swagger = Swaggard.get_doc
    File.open('public/swagger/swaggard.json', 'w') { |file| file.write(JSON.pretty_generate(swagger)) }
    puts 'Swaggard dump complete'
  end
end
