require "mini_magick"

module Mosaic
  class Image
    def initialize(path)
      @path = path
      @image = MiniMagick::Image.open(path)
    end

    def path
      @path
    end

    def width
      @image.width
    end

    def height
      @image.height
    end

    def pixels
      @pixels ||= @image.get_pixels
    end
  end
end
