module Sliders
  def possible_moves(board)
    x, y  = @position[0], @position[1]
    possible_moves = []

    @directions.each do |i, j|
      px, py = x, y
      while true
        px += i
        py += j
        break if !is_on_board?(px, py)

        if !board[px][py].nil?
          if board[px][py].color != @color
            possible_moves << [px, py]
          end
          break
        end

        possible_moves << [px, py]
      end

    end
    possible_moves
  end
end

class Piece
  attr_accessor :color, :symbol, :position

  def initialize(position, color)
    @color = color
    @position = position
  end

  def is_on_board?(x, y)
    x >= 0 && x <= 7 && y >= 0 && y <= 7
  end
end

class Rook < Piece
  include Sliders

  def initialize(position, color)
    super(position, color)
    @symbol = "R"
    @directions = [[0, 1], [0, -1], [1, 0], [-1, 0]]
  end
end

class Knight < Piece
  def initialize(position, color)
    super(position, color)
    @symbol = "N"
  end

  def possible_moves(board)
    possible_moves = []
    x, y  = @position[0], @position[1]
    directions = [[1,2],[2,1],[2,-1],[1,-2],[-1,-2],[-2,-1],[-2,1],[-1,2]]
    directions.each do |i,j|
      if is_on_board?(x + i, y + j)
        if !board[x + i][y + j].nil?
          possible_moves << [x + i, y + j] if board[x + i][y + j].color != @color
        else
          possible_moves << [x + i, y + j]
        end
      end
    end

    possible_moves
  end
end

class Bishop < Piece
  include Sliders

  def initialize(position, color)
    super(position, color)
    @symbol = "B"
    @directions = [[1, 1], [-1, -1], [-1, 1], [1, -1]]
  end
end

class Queen < Piece
  include Sliders

  def initialize(position, color)
    super(position, color)
    @symbol = "Q"
    @directions = [[1, 1], [-1, -1], [-1, 1], [1, -1],
                   [0, 1], [0, -1], [1, 0], [-1, 0]]
  end
end

class King < Piece
  def initialize(position, color)
    super(position, color)
    @symbol = "K"
  end

  def possible_moves(board)
    possible_moves = []
    x, y  = @position[0], @position[1]
    directions = [[1, 1], [-1, -1], [-1, 1], [1, -1],
                   [0, 1], [0, -1], [1, 0], [-1, 0]]
    directions.each do |i,j|
      if is_on_board?(x + i, y + j)
        if !board[x + i][y + j].nil?
          possible_moves << [x + i, y + j] if board[x + i][y + j].color != @color
        else
          possible_moves << [x + i, y + j]
        end
      end
    end
    possible_moves
  end
end

class Pawn < Piece
  def initialize(position, color)
    super(position, color)
    @symbol = "P"
    @directions = [[-1, 0]]
  end

  def possible_moves(board)
    possible_moves = []
    x, y  = @position[0], @position[1]

    if @color == :black
      possible_moves << [3, y] if board[3][y] == nil && x == 1

      if board[x + 1][y] == nil && is_on_board?(x + 1, y)
        possible_moves << [x + 1, y]
      end

      if board[x + 1][y - 1] != nil && board[x + 1][y - 1].color == :white && is_on_board?(x + 1, y - 1)
        possible_moves << [x + 1, y - 1]
      end

      if board[x + 1][y + 1] != nil && board[x + 1][y + 1].color == :white && is_on_board?(x + 1, y + 1)
        possible_moves << [x + 1, y + 1]
      end
    end

    if @color == :white
      possible_moves << [4, y] if board[4][y] == nil && x == 6

      if board[x - 1][y] == nil && is_on_board?(x - 1, y)
        possible_moves << [x - 1, y]
      end

      if board[x - 1][y - 1] != nil && board[x - 1][y - 1].color == :black && is_on_board?(x - 1, y - 1)
        possible_moves << [x - 1, y - 1]
      end

      if board[x - 1][y + 1] != nil && board[x - 1][y + 1].color == :black && is_on_board?(x - 1, y + 1)
        possible_moves << [x - 1, y + 1]
      end
    end

    possible_moves
  end
end

