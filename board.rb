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

   def plant_mines
   end

   
   def [](pos)
      col,row = pos
      @grid[row][col]
   end

   def render
      system("clear")
      puts "  " + (0...@size).to_a.join(" ")
      @grid.each_with_index { |row_tiles, row_i| puts row_i.to_s + " " + row_tiles.map(&:inspect).join(" ") }
   end 

   #TEST METHODS
   def test_adjacent_mines
      @grid[2][3].mine = true
      @grid[3][3].adjacent_mines
   end

end

