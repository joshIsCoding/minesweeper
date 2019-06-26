require_relative "square.rb"
require "byebug"

class Board
   attr_reader :size
   def initialize(size = 9, mine_count = 10)
      @size = size
      @grid = new_grid(size)
      @mine_count = mine_count
      plant_mines
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
      planted_mines = 0
      while planted_mines < @mine_count
         plant_pos = [rand(@size - 1), rand(@size-1)]
         target_square = self[plant_pos]
         if !target_square.mine
            target_square.mine = true
            #
            target_square.revealed = true if __FILE__ != $PROGRAM_NAME
            #
            planted_mines += 1
         end
      end
      planted_mines


   end

   
   def [](pos)
      x,y = pos
      @grid[y][x]
   end

   def reveal_square(pos)
      self[pos].reveal
   end

   def render
      system("clear")
      puts "  " + (0...@size).to_a.join(" ")
      @grid.each_with_index { |row_tiles, row_i| puts row_i.to_s + " " + row_tiles.map(&:to_s).join(" ") }
   end 

   #TEST METHODS
   def test_adjacent_mines(x,y)
      @grid[y][x].adjacent_mines
   end

end

