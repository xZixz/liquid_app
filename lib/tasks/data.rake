namespace :data do
  desc 'Feed dota heroes from json'
  task seed_dota_heroes: :environment do
    file_path = 'heroes.json'
    file = File.read file_path
    data_hash = JSON.parse(file)
    import_hash = data_hash.map do |element|
      r = element.slice('localized_name', 'img')
      r['image'] = r.delete('img')
      r['name'] = r.delete('localized_name')
      r
    end
    Hero.import import_hash
  end
end
