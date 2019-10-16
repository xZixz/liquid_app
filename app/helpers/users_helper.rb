module UsersHelper
  def gravatar_for user, size: 80
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: user.name, class: 'gravatar'
  end

  def hero_avatar_for(user, size: 50)
    hero_name = user.name.split('.').first.gsub('_',' ')
    hero = Hero.where('lower(name) = ?', hero_name.downcase).first
    avatar_url = hero.nil? ? '' : "https://api.opendota.com#{hero.image}"
    image_tag  avatar_url, alt: user.name, class: 'gravatar', height: size
  end
end
