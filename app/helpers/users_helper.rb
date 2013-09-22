# UsersHelper
module UsersHelper
  
  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def avatar_for(user)
    if user.email.blank?
      # echo yava | md5sum
      gravatar_id = "23daa77bc57740dde1d59d4884171c30"
    else
      gravatar_id = Digest::MD5::hexdigest(UnicodeUtils.downcase(user.email))
    end
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?d=retro"
    image_tag(gravatar_url, size: "50x50", alt: user.nickname, class: "avatar img-polaroid")
  end
  
  # returns the name of a provider (TODO: not used anymore?)
  def get_provider(provider)
    if !provider.blank?
      provider.name
    end
  end
end