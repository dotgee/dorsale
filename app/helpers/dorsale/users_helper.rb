module Dorsale::UsersHelper
  def avatar_img(user, url = nil)
    url = user.avatar_url if url.nil?

    image_tag(url,
      :class => "avatar",
      :alt   => user.to_s,
      :title => user.to_s,
    )
  end
end
