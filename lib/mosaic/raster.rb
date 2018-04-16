module Mosaic
  class Raster
    def initialize(rows:, cols:)
      @rows = rows
      @cols = cols
      @pixels = Array.new(@rows) { Array.new(@cols) { [-1, -1, -1] }}
    end

    def add_pixels(rows_of_cols_of_pixels, row_offset, col_offset)
      rows_of_cols_of_pixels.each_with_index do |cols, row|
        cols.each_with_index do |pixel, col|
          add_pixel(row + row_offset, col + col_offset, pixel)
        end
      end
    end

    def add_pixel(row, col, pixel)
      @pixels[row][col] = pixel
    end

    def method_missing(sym, *args, &block)
      @pixels.public_send(sym, *args, &block)
    end
  end
end

