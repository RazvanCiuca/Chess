require_relative "./pieces.rb"
require_relative "./board.rb"
require "colorize"

class HumanPlayer
  def move
    p "Enter your move:"
    move = gets.chomp.split(" ").map(&:to_i)
  end
end

class Game
  def initialize
    @board_object = Board.new
    @board = @board_object.board
    @players = [HumanPlayer.new, HumanPlayer.new]
    @turn = 0
  end

  def play
    until false
      @board_object.display
      move = @players[@turn].move
      p check_move(move)
      if check_move(move)
        @board_object.move(move[0..1], move[2..3])
        @board[move[2]][move[3]].position = move[2..3]
      end
      @turn = 1 - @turn
    end
  end

  def check_move(move)
    piece = @board[move[0]][move[1]]
    type = piece.class
    side = piece.color
    possible_moves = piece.possible_moves(@board)

    unless possible_moves.include?([move[2], move[3]])
      return false
    end
    true
  end
end

game = Game.new
game.play