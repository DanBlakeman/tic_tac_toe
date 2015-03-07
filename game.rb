#----------------
# CELL
#----------------

class Cell

  attr_accessor :mark

  def initialize(mark = "")
    @mark = mark
  end

end



#----------------
# PLAYER
#----------------

class Player

  attr_reader :mark

  def initialize(settings_hsh)
    @mark = settings_hsh.fetch(:mark)
    @name = settings_hsh.fetch(:name)
  end
end

#----------------
# BOARD
#----------------
class Board

  attr_accessor :grid

  def initialize(input = {})
    @grid = input.fetch(:grid, default_grid)
  end


  def mark_cell(row, column, mark)
    @grid[row - 1][column - 1].mark
  end


  private

  def default_grid
    Array.new(3) { array.new(3) {Cell.new}}
  end
end


#----------------
# GAME
#----------------

class Game
  attr_reader :players :current_player

  def initialize(players, board)
    @players = players
    @board = board
    @current_player, @other_player = players.shuffle
  end

  def play
    puts "#{current_player.name}'s turn"
    ...get input, sanitise input, draw board etc
    while true
      #play game
      #if won? || draw?return you win or draw!
    else switch players
    end
#run a loop that gets input, passes it to board, switches player, posts to board state until game is won or draw (loop exits).
  end

  def translate_command_to_board(command)
    #Give it a number, translate that number to row and column send to the board the row, column and current player.mark
  end

  def current_player
    @players[0]
  end

  def switch_players
    @current_player, @other_player = @other_player, @current_player
  end

  def won?
  end

  def draw?
  end

#Game.new([player1, player2], Board.new)
end

#game.play