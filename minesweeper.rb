require_relative "board.rb"
require "byebug"
require "yaml"
class Minesweeper
   SAVE_PATH = "./save_games/save_state.txt"
   
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
         save_game
      end
      if game_won?
         win_message 
      else
         lose_message
      end
      delete_save
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
      get_pos
   end

   def get_pos
      move = nil
      until move
         move = @board.cursor.get_input
         @board.render
      end
      move
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

   def win_message
      puts "Nice work! You identified all of the mines."
   end
   
   def lose_message
      puts "You detonated a mine! Gameover."
   end
   


   def save_game
      save_game = File.open(SAVE_PATH, "w")
      serialisation = self.to_yaml
      save_game.puts serialisation
      save_game.close
   end

   def delete_save
      File.delete(SAVE_PATH) if File.exist?(SAVE_PATH)
   end


   
   def self.load_from_save
      recovered_save = File.read(SAVE_PATH) if File.exist?(SAVE_PATH)
      YAML::load(recovered_save)
   end
      


end

game = Minesweeper.new
game.play
