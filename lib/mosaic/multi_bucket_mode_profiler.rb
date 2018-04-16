require "mosaic/enumerable_ext"

module Mosaic
  class MultiBucketModeProfiler
    MAX_INTENSITY = 256
    DEFAULT_NUM_BUCKETS = 20

    def initialize(num_buckets = DEFAULT_NUM_BUCKETS)
      @num_buckets = num_buckets
    end

    def profile(image_or_region)
      (0..2).map do |plane|
        plane_pixels = image_or_region.pixels.flat_map { |cols| cols.map { |pixels| pixels[plane] }}
        buckets = plane_pixels.map { |i| bucket(i, @num_buckets) }
        buckets.mode
      end
    end

    def distance(a, b)
      (0..2).map { |plane| (a[plane] - b[plane]).abs }.sum
    end

    private

    def bucket(intensity, num_buckets)
      bucket_size = MAX_INTENSITY / num_buckets
      intensity / bucket_size
    end
  end
end

