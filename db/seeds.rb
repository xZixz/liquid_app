# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

User.create!(name: 'Rubick', email: 'superman@earth.com',
             password: '123456', 'password_confirmation': '123456',
             admin: true, activated: true, activated_at: Time.zone.now)

99.times do |num|
  name = Faker::Games::Dota.hero.downcase.gsub(' ', '_') + ".#{num}"
  email = "#{name}@valve.com"
  p email
  User.create!(name: name, email: email,
               password: '123456', 'password_confirmation': '123456',
               activated: true, activated_at: Time.zone.now)
end

# Other data rake tasks
Rake::Task['data:seed_dota_heroes'].invoke
