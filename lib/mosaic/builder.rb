require "tempfile"
require "mosaic/base"
require "mosaic/png"
require "mosaic/image"
require "mosaic/raster"

module Mosaic
  class Builder
    def initialize(base_image:, config:)
      @base_image = base_image
      @source_images = []
      @config = config
      @profiler = config.profiler
    end

    def add_source_images(source_images)
      @source_images += source_images
    end

    def build!
      base = Mosaic::Base.new(@base_image, @config)

      $logger.info "#{self.class}.build!: profiling each region"
      profiled_regions = profile(base.regions, @profiler)
      $logger.info "#{self.class}.build!: generated #{profiled_regions.length} profiles"

      $logger.info "#{self.class}.build!: downscaling the source images"
      downscaled_source_images = downscale_images(@source_images, @profiler)

      $logger.info "#{self.class}.build!: profiling the source images"
      profiled_source_images = profile(downscaled_source_images, @profiler)
      $logger.info "#{self.class}.build!: generated #{profiled_source_images.length} profiles"

      $logger.info "#{self.class}.build!: mapping regions to source images"
      regions_to_images = map_regions_to_source_images(@profiler, profiled_regions, profiled_source_images)
      $logger.info "#{self.class}.build!: done mapping regions to source images"

      $logger.info "#{self.class}.build!: constructing mosaic"
      write_mosaic(regions_to_images, "out.png")
    end

    private

    def downscale_images(images, profiler)
      images.map do |image|
        scaled_image_path = Tempfile.new("scaled_image").path
        dimensions = "#{@config.desired_width / @config.num_regions_horizontal}x#{@config.desired_height / @config.num_regions_vertical}"
        Mosaic::Transform.resize(image.path, scaled_image_path, dimensions, ignore_aspect_ratio: true)
        Mosaic::Image.new(scaled_image_path)
      end
    end

    def profile(images_or_regions, profiler)
      images_or_regions.map do |image_or_region|
        profiler_out = profiler.profile(image_or_region)
        $logger.debug "#{self.class}.build!: profiler out = #{profiler_out}"
        [image_or_region, profiler_out]
      end
    end

    def map_regions_to_source_images(profiler, profiled_regions, profiled_source_images)
      profiled_regions.map do |(region, region_profile)|
        closest_image, _ =
          profiled_source_images.min_by do |(image, img_profile)|
            profiler.distance(img_profile, region_profile)
          end

        [region, closest_image]
      end
    end

    def build_raster(regions_to_images)
      raster = Mosaic::Raster.new(rows: @config.desired_height, cols: @config.desired_width)
      regions_to_images.each do |(region, image)|
        raster.add_pixels(image.pixels, region.first_row, region.first_col)
      end
      raster
    end

    def write_mosaic(regions_to_images, output)
      raster = build_raster(regions_to_images)
      Mosaic::PNG.from_raster(raster, output)
    end
  end
end
