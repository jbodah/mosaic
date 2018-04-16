require 'mosaic/transform'
require 'mosaic/image'
require 'mosaic/square_image_region'

module Mosaic
  class Base
    def initialize(image, config)
      @image = image
      @config = config
    end

    def regions
      $logger.debug "#{self.class}.regions: scaling #{@image.path} to #{@config.desired_width}x#{@config.desired_height}"
      scaled_path = Tempfile.new("scaled.png").path
      # TODO: @jbodah 2018-04-15: cropping
      Mosaic::Transform.resize(@image.path, scaled_path, "#{@config.desired_width}x#{@config.desired_height}", ignore_aspect_ratio: true)
      scaled_image = Mosaic::Image.new(scaled_path)

      $logger.debug "#{self.class}.regions: breaking #{@image.path} into regions"
      break_into_regions(scaled_image)
    end

    private

    def break_into_regions(image)
      num_cols = @config.num_regions_horizontal
      num_rows = @config.num_regions_vertical
      region_height = (@config.desired_width / num_rows)
      region_width = (@config.desired_height / num_cols)
      num_rows.times.flat_map do |row_n|
        num_cols.times.map do |col_n|
          Mosaic::SquareImageRegion.new(
            image: image,
            width: region_width,
            height: region_height,
            first_row: row_n * region_height,
            first_col: col_n * region_width
          )
        end
      end
    end
  end
end
