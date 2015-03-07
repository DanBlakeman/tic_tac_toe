#----------------
# CELL
#----------------

class Cell

  attr_accessor :mark

  def initialize(mark = " ")
    @mark = mark
  end

end



#----------------
# PLAYER
#----------------

class Player

  attr_reader :mark, :name

  def initialize(settings_hsh)
    @mark = settings_hsh.fetch(:mark)
    @name = settings_hsh.fetch(:name)
  end
end

#----------------
# BOARD
#----------------
class Board

  attr_accessor :grid, :show, :mark

  def initialize(input = {})
    @grid = input.fetch(:grid, default_grid)
  end


  def mark_cell(row, column, players_mark)
    puts @grid[row - 1][column - 1].mark = players_mark
  end

  def show
    grid.each do |row|
      p row.map { |cell| cell.mark }
    end
  end


  private

  def default_grid
    Array.new(3) { Array.new(3) {Cell.new}}
  end

end


#----------------
# GAME
#----------------

class Game

  def initialize(players, board=Board.new)
    @players = players
    @board = board
    @current_player, @other_player = players.shuffle
    @current_player = Player.new(@current_player)
    @other_player = Player.new(@other_player)
  end

  attr_reader :current_player #:players

  def play

    while true
      puts "#{@current_player.name}'s turn, you're counter is #{@current_player.mark}"
      @board.show
      puts "Which row would you like to place a counter?"
      row = gets.chomp.to_i
      puts "Which column would you like to place a counter?"
      column = gets.chomp.to_i
      @board.mark_cell(row, column, @current_player.mark)
      @board.show
      if won?
        puts "ZOMG #{@current_player.name.upcase} WON!!"
        break
      end
      if draw?
        puts "IT'S A DRAW - IT'S LIKE A BATTLE OF TITONS!"
      end
      switch_players
    end
    #...get input, sanitise input, draw board etc
   # while true
      #play game
      #if won? || draw?return you win or draw!
    #else switch players
   # end
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

    (0..2).each do |row|
      return true if @board.grid[row].all? { |cell| cell.mark == @current_player.mark }
    end

    (0..2).each do |column|
      result = []
      @board.grid.each {|row| result << row[column]}
      return true if result.all? {|cell| cell.mark == @current_player.mark }
    end

    top_left_diagonal =[@board.grid[0][0].mark, @board.grid[1][1].mark, @board.grid[2][2].mark]
    top_right_diagonal = [@board.grid[0][2].mark, @board.grid[1][1].mark, @board.grid[2][0].mark]
    winning_combination = Array.new(3) {@current_player.mark}


    return true if top_left_diagonal == winning_combination || top_right_diagonal == winning_combination


    false
  end

  def draw?
    @board.grid.flatten.all? { |cell| cell.mark != " " }
  end

end

game = Game.new([{:name => "Dan", :mark => "x"}, {:name => "Sam", :mark => "o"}], Board.new)

game.play