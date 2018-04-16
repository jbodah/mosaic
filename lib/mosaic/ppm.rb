module Mosaic
  class PPM
    # PPM is an image format that allows us to define raster images (or in laymans terms,
    # define an image from a direct pixel array)
    #
    # PPM Specifcation: http://netpbm.sourceforge.net/doc/ppm.html

    P3 = "P3".freeze
    P6 = "P6".freeze
    DEFAULT_MAX_INTENSITY = 256

    def self.from_raster(raster)
      rows = raster.length
      cols = raster[0].length
      ppm = new(rows: rows, cols: cols, pixels: raster)
    end

    def initialize(magic_number: P3, rows:, cols:, pixels:, max_intensity: DEFAULT_MAX_INTENSITY)
      @magic_number = magic_number
      @rows = rows
      @cols = cols
      @max_intensity = max_intensity
      @pixels = pixels
    end

    def to_s
      raster_body = @pixels.map { |cols| cols.map { |rgb| rgb.join(' ') }.join("\t") }.join("\n")
      <<~EOF
      #{@magic_number}
      #{@rows} #{@cols}
      #{@max_intensity}
      #{raster_body}
      EOF
    end
  end
end
