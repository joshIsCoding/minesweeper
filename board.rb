require_relative "square.rb"
require "byebug"

class Board
   attr_reader :size
   def initialize(size)
      @size = size
      @grid = new_grid(size)
      @mine_count = 0
   end

   def new_grid(size)
      new_grid = Array.new(size) { Array.new }
      new_grid.each_with_index do |grid_row, y|
         (0...size).each do |x|
            square_pos = [x, y]
            grid_row << Square.new(square_pos, self)
         end
      end
      
      new_grid
   end

   def test_adjacent_mines
      @grid[2][3].mine = true
      @grid[3][3].adjacent_mines
   end

   def [](pos)
      col,row = pos
      @grid[row][col]
   end
end

