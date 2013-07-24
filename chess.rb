require_relative "./pieces.rb"
require_relative "./board.rb"
require "colorize"

class HumanPlayer
  attr_reader :king_position, :color
  MAP = {"a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h" => 7}
  def move
    actual_move = []
    p "Enter your move, #{color}:"
    move = gets.chomp.split(" ")
    move.each do |pos|
      actual_move << 7 - pos.split("")[1].to_i
      actual_move << MAP[pos.split("")[0]]
    end

    actual_move
  end

  def initialize(color)
    @king_position = (color == :white ? [7, 4] : [0, 4])
    @color = color
  end
end

class Game
  def initialize
    @board_object = Board.new
    @board = @board_object.board
    @players = [HumanPlayer.new(:white), HumanPlayer.new(:black)]
    @player = 0
  end

  def play
    until false
      @board_object.display
      move = @players[@player].move
      if check_move(move)
        @board_object.move(move[0..1], move[2..3])
        @board[move[2]][move[3]].position = move[2..3]
      end

      if check_for_check(1 - @player) #check if you just checked your opponent
        p "Check for #{1 - @player}"
      end

      @player = 1 - @player
    end
  end

  def check_move(move)
    piece = @board[move[0]][move[1]]

    possible_moves = piece.possible_moves(@board)

    unless possible_moves.include?([move[2], move[3]])
      return false
    end

    if check_for_check(@player) #check yourself before you wreck yourself
      return false
    end
    true
  end

  def check_for_check(player)
    color_of_players = {0 => :white, 1 => :black}
    possible_check = []
    @board.each do |line|
      line.each do |tile|
        if tile && tile.color != color_of_players[player]
          danger_zone = tile.possible_moves(@board)
          if danger_zone.include?(@players[player].king_position)
            return true
          end
        end
      end
    end
    false
  end
end

game = Game.new
game.play