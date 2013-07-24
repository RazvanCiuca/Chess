#encoding: utf-8
class Board
  COLORS = {:white => :red, :black => :black}

  attr_accessor :board

  def initialize(with_pieces = true)
    @board = Array.new(8) { Array.new(8, nil) } #make 8 x 8 empty board
    if with_pieces
      pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
      #make black special pieces
      pieces.each_with_index do |piece, i|
        @board[0][i] = piece.new([0, i], :black)
      end
      #make white special pieces
      pieces.each_with_index do |piece, i|
        @board[7][i] = piece.new([7, i], :white)
      end
      #make black pawns
      8.times do |i|
        @board[1][i] = Pawn.new([1, i], :black)
      end
      #make white pawns
      8.times do |i|
        @board[6][i] = Pawn.new([6, i], :white)
      end
    end
  end

  def display
    puts "  a b c d e f g h"
    background_colors = {0 => :light_white, 1 => :white}
    @board.each_with_index do |line, i|
      print "#{8 - i} "
      line.each_with_index do |tile, j|
        color = (i + j) % 2
        if tile.nil?

          print "  ".colorize(:color => :green, :background => background_colors[color] )
        else
          print (tile.symbol+ " ").colorize( {:color => COLORS[tile.color], :background => background_colors[color]} )
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
