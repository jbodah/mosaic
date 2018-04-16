require "mini_magick"

module Mosaic
  module Transform
    class << self
      def to_greyscale(input, output)
        convert "-colorspace Gray #{input} #{output}"
      end

      def resize(input, output, dimensions, opts)
        suffix = opts[:ignore_aspect_ratio] ? '!' : ''
        convert "#{input} -resize #{dimensions}#{suffix} #{output}"
      end

      def transcode(input, output)
        convert "#{input} #{output}"
      end

      private

      def convert(str)
        $logger.debug "#{self.class}.convert: Running 'convert #{str}'"
        MiniMagick::Tool::Convert.new do |tool|
          tool.merge! str.split
        end
      end
    end
  end
end
