require "mini_magick"

class Dorsale::AvatarUploader < ::Dorsale::ImageUploader
  include CarrierWave::MiniMagick

  process resize_to_fill: [200, 200]
end
