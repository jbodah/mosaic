require "mosaic/version"
require "mosaic/config"
require "mosaic/image"
require "mosaic/builder"

$logger = Logger.new($stdout)

module Mosaic
  def self.create(config)
    base_image = Mosaic::Image.new(config.base_image)
    source_images = config.source_images.map { |img| Mosaic::Image.new(img) }

    builder = Mosaic::Builder.new(base_image: base_image, config: config)
    builder.add_source_images(source_images)

    $logger.debug "#{self.class}.create: calling Mosaic::Builder#build!"

    output = builder.build!
  end
end
