# encoding: utf-8
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
          p "#{@players[@turn].color} crushed #{@players[1 - @turn].color}"
          @board_object.display
          break
        end
        puts
        print @king_position
        puts
        p "Check for #{1 - @turn}"
      end

      @turn = 1 - @turn
    end
  end

  def dup
    new_board = Board.new(false)
    @board.each_with_index do |line, i|
      line.each_with_index do |tile, j|
        if tile
          new_board.board[i][j] = @board[i][j].class.new([i,j], tile.color)
        end
      end
    end

    new_board
  end

  def check_for_mate
    p "Entering check_for_mate"
    @board.each do |line|
      line.each do |tile|
        if tile && tile.color != COLOR_OF_PLAYERS[@turn]
          possible_moves = tile.possible_moves(@board)
          possible_moves.each do |destination|
            move = tile.position + destination
            new_board = dup
            if @board[move[0]][move[1]].symbol == "K"
              @king_position[1 - @turn] = move[2..3]
            end
            new_board.move(move[0..1], move[2..3])
            new_board.board[move[2]][move[3]].position = move[2..3]

            if !check_for_check(1 - @turn, new_board.board)
              @king_position[1 - @turn] = move[0..1]
              return false
            end
            #@king_position[1 - @turn] = move[0..1]
          end

        end

      end
    end
    true
  end

  def bigger_move_method
    move = @players[@turn].move

    unless @board[move[0]][move[1]].color == COLOR_OF_PLAYERS[@turn]
      raise ArgumentError.new "That's not your piece, bitch!"
    end

    unless check_move(move)
      raise ArgumentError.new "Move is not valid"
    end

    if @board[move[0]][move[1]].symbol == "K"
      p "king shouldnt move here"
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
    new_board = dup
    if @board[move[0]][move[1]].symbol == "K"
      @king_position[@turn] = move[2..3]
    end
    new_board.move(move[0..1], move[2..3])
    new_board.board[move[2]][move[3]].position = move[2..3]

    #check yourself before you wreck yourself
    if check_for_check(@turn, new_board.board)
      @king_position[@turn] = move[0..1]
      return false
    end

    true
  end

  def check_for_check(player, board)
    board.each do |line|
      line.each do |tile|
        if tile && tile.color != COLOR_OF_PLAYERS[player]
          danger_zone = tile.possible_moves(board)
          if danger_zone.include?(@king_position[1 - @turn])
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