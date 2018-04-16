module Mosaic
  class SquareImageRegion
    def initialize(image:, width:, height:, first_row:, first_col:)
      @width = width
      @height = height
      @first_row = first_row
      @first_col = first_col
      @image = image
    end

    def pixels
      @image.pixels.slice(@first_row, @width).map do |row|
        row.slice(@first_col, @height)
      end
    end

    def width
      @width
    end

    def height
      @height
    end

    def first_row
      @first_row
    end

    def first_col
      @first_col
    end
  end
end
