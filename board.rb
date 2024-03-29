require_relative "square.rb"
require_relative "cursor.rb"

class Board
   attr_reader :cursor, :size, :mine_count, :revealed_squares
   MINESWEEPER_FILE = "minesweeper.rb"
   def initialize(size = 9, mine_count = 10)
      
      @size = size
      @grid = new_grid(size)
      @revealed_squares = 0
      @mine_count = mine_count
      plant_mines

      @cursor = Cursor.new([0,0], self)
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
         plant_pos = [rand(@size), rand(@size)]
         target_square = self[plant_pos]
         if !target_square.mine
            target_square.mine = true
            
            # when debugging, reveal mines by default
            target_square.revealed = true if !$PROGRAM_NAME.include?(MINESWEEPER_FILE)
            
            planted_mines += 1
         end
      end
      planted_mines


   end

   
   def [](pos)
      x,y = pos
      @grid[y][x] if valid_pos?(pos)
   end

   def valid_pos?(pos)
      pos.min >= 0 && pos.max < size
   end

   def reveal_square(pos)
      @revealed_squares = revealed_squares unless self[pos].revealed      
      self[pos].reveal
   end

   def flag_square(pos)
      self[pos].flag
   end
   
   def revealed_squares
      @grid.flatten.count{ |square| square.revealed && !square.mine }
   end

   def render
      system("clear")
      print_horizontal_line
      @grid.each_with_index { |row_tiles, row_i| puts "|" + row_tiles.map(&:to_s).join("") + "|" }
      print_horizontal_line(true) 
   end 

   def print_horizontal_line(bottom = false)
      bookend = bottom ? "|" : " "
      print bookend
      @size.times{ print "___"}
      puts bookend
   end


end


