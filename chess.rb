require "colorize"

class Piece
  attr_accessor :color, :symbol, :position

  def initialize(position, color)
    @color = color
    @position = position
  end
end

class Rook < Piece
  def initialize(position, color)
    super(position, color)
    @symbol = "R"
  end

  def possible_moves
    x, y  = @position[0], @position[1]
    possible_moves = []
    (-7..7).each do |i|
      possible_moves << [x + i, y]
      possible_moves << [x - i, y]
      possible_moves << [x, y + i]
      possible_moves << [x, y - i]
    end

    possible_moves.delete([x, y])
    possible_moves.select! do |i, j|
      within_board? = i >= 0 && i < 8 && j >= 0 && j < 8
      if board[i][j]
        color_not_same? = board[i][j].color != self.color
      end
    end
  end
end

class Knight < Piece
  def initialize(position, color)
    super(position, color)
    @symbol = "N"
  end
end

class Bishop < Piece
  def initialize(position, color)
    super(position, color)
    @symbol = "B"
  end
end

class Queen < Piece
  def initialize(position, color)
    super(position, color)
    @symbol = "Q"
  end
end

class King < Piece
  def initialize(position, color)
    super(position, color)
    @symbol = "K"
  end
end

class Pawn < Piece
  def initialize(position, color)
    super(position, color)
    @symbol = "P"
  end
end


class HumanPlayer
  def move
    p "Enter your move:"
    move = gets.chomp.split(" ").map(&:to_i)
  end
end

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
    @board.each do |line|
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
    possible_moves = piece.possible_moves
    # print possible_moves
    unless possible_moves.include?([move[2], move[3]])
      return false
    end
    true
  end
end

game = Game.new
game.play