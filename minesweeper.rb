require_relative "board.rb"
require "byebug"
class Minesweeper
   def initialize(board_size=9, difficulty="easy")
      @total_squares = board_size * board_size
      case difficulty
      when "easy"
         @board = Board.new(board_size)
      when "medium"
         @board = Board.new(board_size, 20)
      when "hard"
         @board = Board.new(board_size, 30)
      end
      @gameover = false
   end

   def play
      until @gameover
         @board.render
         next_move
      end
      if game_won?
         winner 
      else
         loser
      end
   end

   def next_move
      move_type, pos = get_move
      if move_type == "f"
         @board.flag_square(pos)
      else
         mine = @board.reveal_square(pos)
         if @game_won
            debugger
         end
         
         @gameover = true if mine || game_won?
      end
   end

   def get_move
      request_pos
      new_pos = get_pos
      until valid_pos?(new_pos)
         puts "Those ain't valid coordinates! Please try again:"
         new_pos = get_pos
      end
      
      request_move_type
      new_move_type = get_move_type
      until valid_move_type?(new_move_type)
         puts "That's not a valid move! Please enter either 'f' or 'r':"
         new_move_type = get_move_type
      end
      [new_move_type, new_pos]
   end

   def get_pos
      parse_pos(gets.chomp)
   end

   def get_move_type
      parse_move_type(gets.chomp)
   end

   def parse_pos(string)
      begin
         parsed_pos = string.split(",").map(&:to_i)
      rescue 
         parsed_pos ||= []
      end
      parsed_pos
   end

   def parse_move_type(string)
      string.downcase.strip
   end

   def valid_pos?(new_pos)
      
      new_pos.length == 2 && new_pos.all?{ |coord| coord >= 0 && coord < @board.size }
   end

   def valid_move_type?(new_move_type)
      new_move_type == "r" || new_move_type == "f"
   end

   def request_pos
      puts "Enter a square position in the format x,y:"
   end

   def request_move_type
      puts "Enter either 'r' or 'f' to reveal or flag the chosen square, respectively:"
   end

   def game_won?
      @total_squares - @board.mine_count == @board.revealed_squares
   end
      


end