module Mosaic
  class BinaryThresholdProfiler
    MAX_INTENSITY = 256
    DEFAULT_THRESHOLD = MAX_INTENSITY/2

    def initialize(threshold = DEFAULT_THRESHOLD)
      @threshold = threshold
    end

    def profile(image_or_region)
      binary_pixels = image_or_region.pixels.flat_map { |cols| cols.map { |pixels| pixels[0] }}
      over_threshold = binary_pixels.count { |i| i > @threshold }
      over_threshold * 1.0 / binary_pixels.length
    end

    def distance(a, b)
      (a - b).abs
    end
  end
end
