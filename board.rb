class Board
  COLORS = {:white => :light_white, :black => :red}

  attr_accessor :board

  def initialize
    @board = Array.new(8) { Array.new(8, nil) }
    @board[0][0] = Rook.new([0, 0], :black)
    @board[0][7] = Rook.new([0, 7], :black)
    @board[0][1] = Knight.new([0, 1], :black)
    @board[0][6] = Knight.new([0, 6], :black)
    @board[0][2] = Bishop.new([0, 2], :black)
    @board[0][5] = Bishop.new([0, 5], :black)
    @board[0][3] = Queen.new([0, 3], :black)
    @board[0][4] = King.new([0, 4], :black)
    8.times do |i|
      @board[1][i] = Pawn.new([1, i], :black)
    end

    @board[7][0] = Rook.new([7, 0], :white)
    @board[7][7] = Rook.new([7, 7], :white)
    @board[7][1] = Knight.new([7, 1], :white)
    @board[7][6] = Knight.new([7, 6], :white)
    @board[7][2] = Bishop.new([7, 2], :white)
    @board[7][5] = Bishop.new([7, 5], :white)
    @board[7][3] = Queen.new([7, 3], :white)
    @board[7][4] = King.new([7, 4], :white)
    8.times do |i|
      @board[6][i] = Pawn.new([6, i], :white)
    end
  end

  def display
    puts "  a b c d e f g h"
    @board.each_with_index do |line, i|
      print "#{7 - i} "
      line.each do |tile|
        if tile.nil?
          print ". "
        else
          print tile.symbol.send(COLORS[tile.color]) + " "
        end
      end
      puts
    end
  end

  def move(origin, destination)
    origin_x, origin_y = origin
    destination_x, destination_y = destination

    @board[destination_x][destination_y] = @board[origin_x][origin_y]
    @board[origin_x][origin_y] = nil
  end
end
