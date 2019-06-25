require_relative "board.rb"
require "byebug"
class Square
   attr_accessor :mine
   def initialize(pos, board)
      @mine = false
      @revealed = false
      @flagged = false

      @x, @y = pos
      @board = board
   end

   def adjacent_mines
      adjacent_mines = 0
      (-1..1).each do |y_delta|
         (-1..1).each do |x_delta|
            next if y_delta == 0 && x_delta ==0
            neighbour_pos = [@x + x_delta, @y + y_delta]
            
            if neighbour_pos.none?{ |coord| coord < 0 || coord >= @board.size }
               #debugger
               adjacent_mines += 1 if @board[neighbour_pos].mine
            end
         end
      end
      adjacent_mines
   end

end





