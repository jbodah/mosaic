require "fileutils"
require "mosaic/ppm"
require "mosaic/transform"

module Mosaic
  module PNG
    def self.from_raster(raster, output)
      ppm = Mosaic::PPM.from_raster(raster)

      $logger.info "#{self}.#{__method__}: writing PPM to tmp.ppm"
      File.write("tmp.ppm", ppm.to_s)

      $logger.info "#{self}.#{__method__}: transcoding PPM to desired format in #{output}"
      Mosaic::Transform.transcode("tmp.ppm", output)

      $logger.info "#{self}.#{__method__} deleting tmp.ppm"
      FileUtils.rm("tmp.ppm")
    end
  end
end
