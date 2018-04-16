module Mosaic
  class Config
    attr_reader :base_image, :source_images, :num_regions_horizontal, :num_regions_vertical, :desired_width, :desired_height, :profiler

    def initialize(hash)
      @base_image = hash[:base_image]
      @source_images = hash[:source_images]
      @num_regions_horizontal = hash[:num_regions_horizontal]
      @num_regions_vertical = hash[:num_regions_vertical]
      @desired_width = hash[:desired_width]
      @desired_height = hash[:desired_height]
      @profiler = hash[:profiler]
    end
  end
end
