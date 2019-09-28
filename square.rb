require "colorize"
class Square
   attr_accessor :mine, :revealed, :flagged
   COLOURS = { 
      mine: :black,
      flag: :green,
      clear: :light_black,
      1 => :light_green,
      2 => :light_blue,
      3 => :blue,
      4 => :light_red,
      5 => :red,
      6 => :red,
      7 => :red,
      8 => :red
   }

   def initialize(pos, board)
      @mine = false
      @revealed = false
      @flagged = false

      @x, @y = pos
      @board = board
   end

   def neighbours
      neighbours = []
      (-1..1).each do |y_delta|
         (-1..1).each do |x_delta|
            next if y_delta == 0 && x_delta ==0
            neighbour_pos = [@x + x_delta, @y + y_delta]
            
            if neighbour_pos.none?{ |coord| coord < 0 || coord >= @board.size }
               neighbours << @board[neighbour_pos]
            end
         end
      end
      neighbours
   end

   def adjacent_mines
      adjacent_mines = 0
      neighbours.each do |neighbour_square|
         adjacent_mines += 1 if neighbour_square.mine
      end
      adjacent_mines
   end

  
         

   def reveal
      if !(@revealed || @flagged)
         @revealed = true
         if !@mine
            if adjacent_mines == 0
               
               neighbours.each do |neighbour_square|
                  neighbour_square.reveal if !neighbour_square.mine
               end
            end
         end
         return @mine
      end
   end

   def flag
      if @flagged
         @flagged = false
      else
         @flagged = true
      end
   end

   def to_s
      colour_options = {}
      colour_options[:background] = :white if [@x, @y] == @board.cursor.cursor_pos
      if @revealed
         if @mine
            return " * ".colorize(COLOURS[:mine]).on_red
         elsif adjacent_mines !=0
            adj_mines = adjacent_mines
            colour_options[:color] = COLOURS[adj_mines]
            return " " + adj_mines.to_s.colorize(colour_options) + " "
         else
            colour_options[:color] = COLOURS[:clear]
            return " - ".colorize(colour_options)
         end
      elsif @flagged
         colour_options[:color] = COLOURS[:flag]
         return " F ".colorize(colour_options)
      else
         return " _ ".colorize(colour_options)
      end
   end

   def inspect
      { 'mine?' => @mine, 'revealed?' => @revealed, 'flagged?' => @flagged = false, 'pos' => [@x,@y] }.inspect
   end
 

end





