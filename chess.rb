require_relative "./pieces.rb"
require_relative "./board.rb"
require "colorize"
require "YAML"

class HumanPlayer
  attr_accessor :color

  MAP = {"a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h" => 7}

  def move
    actual_move = []

    p "Enter your move, #{color}:"
    move = gets.chomp.split(" ")
    move.each do |pos|
      actual_move << 8 - pos.split("")[1].to_i
      actual_move << MAP[pos.split("")[0]]
    end
    actual_move
  end

  def initialize(color)
    @color = color
  end
end

class Game
  COLOR_OF_PLAYERS = {0 => :white, 1 => :black}

  def initialize
    @board_object = Board.new
    @board = @board_object.board
    @players = [HumanPlayer.new(:white), HumanPlayer.new(:black)]
    @king_position = [[7, 4], [0, 4]]
    @turn = 0
  end

  def play
    until false
      @board_object.display

      begin
        bigger_move_method
      rescue ArgumentError => e
        puts e.message
        retry
      end

      if check_for_check(1 - @turn, @board)
        if check_for_mate
        p "Check for #{1 - @player}"
      end

      @turn = 1 - @turn
    end
  end

  def check_for_mate

  def bigger_move_method
    move = @players[@turn].move

    unless @board[move[0]][move[1]].color == COLOR_OF_PLAYERS[@turn]
      raise ArgumentError.new "That's not your piece, bitch!"
    end

    unless check_move(move)
      raise ArgumentError.new "Move is not valid"
    end

    if @board[move[0]][move[1]].symbol == "K"
      @players[@turn].king_position = move[2..3]
    end

    @board_object.move(move[0..1], move[2..3])
    @board[move[2]][move[3]].position = move[2..3]
  end

  def check_move(move)
    piece = @board[move[0]][move[1]]
    possible_moves = piece.possible_moves(@board)
    #is a possible move?
    unless possible_moves.include?([move[2], move[3]])
      return false
    end
    #dup the board
    new_board = @board_object.to_yaml
    new_board = YAML.load(new_board)
    if @board[move[0]][move[1]].symbol == "K"
      @king_position[@turn] = move[2..3]
    end
    new_board.move(move[0..1], move[2..3])
    new_board.board[move[2]][move[3]].position = move[2..3]

    #check yourself before you wreck yourself
    if check_for_check(@turn, new_board.board)
      @king_position[@turn] = move[0..1]
      p "hi"
      return false
    end

    true
  end

  def check_for_check(player, board)
    board.each do |line|
      line.each do |tile|
        if tile && tile.color != COLOR_OF_PLAYERS[player]
          danger_zone = tile.possible_moves(board)
          if danger_zone.include?(@king_position[@turn])
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