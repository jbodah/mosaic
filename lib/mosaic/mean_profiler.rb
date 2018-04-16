module Mosaic
  class MeanProfiler
    MAX_INTENSITY = 256
    DEFAULT_NUM_BUCKETS = 20

    def initialize(planes: [0, 1, 2])
      @planes = planes
    end

    def profile(image_or_region)
      @planes.map do |plane|
        plane_pixels = image_or_region.pixels.flat_map { |cols| cols.map { |pixels| pixels[plane] }}
        plane_pixels.sum / plane_pixels.length
      end
    end

    def distance(a, b)
      a.zip(b).map { |plane_avg_a, plane_avg_b| (plane_avg_a - plane_avg_b).abs }.max
    end
  end
end
