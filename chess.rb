require "colorize"

class Piece
  attr_accessor :color, :symbol, :position

  def initialize(position, color)
    @color = color
    @position = position
  end
end

class Rook < Piece
  attr_accessor :position, :color, :symbol

  def initialize(position, color)
    super(position, color)
    @symbol = "R"
  end
end

class HumanPlayer

end

class Board
  def initialize
    @board = Array.new(8) { Array.new(8, nil) }
    @board[0][0] = Rook.new([0, 0], :light_white)
  end

  def display
    @board.each do |line|
      line.each do |tile|
        if tile.nil?
          print ". ".light_white
        else
          print tile.symbol.send(tile.color) + " "
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

board = Board.new
board.display
board.move([0, 0], [7, 7])
board.display