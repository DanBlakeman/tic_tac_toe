#----------------
# CELL
#----------------

class Cell

  attr_accessor :mark, :default_mark

  def initialize(empty_cell_mark = " ")
    @mark = empty_cell_mark
    @default_mark = empty_cell_mark
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
    @grid[row - 1][column - 1].mark = players_mark
  end

  def show
    print "\n"
    grid.each do |row|
      x =  row.map { |cell| cell.mark }
      print "---------\n" unless row == grid.first
      print x.join(" | "), "\n"
    end
    print "\n"
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

  attr_reader :current_player

  def initialize(board=Board.new)
    user_create_players
    @current_player, @other_player = [@current_player, @other_player].shuffle

    @board = board #Can remove once save feature working
  end

  def user_create_players
     puts "PLAYER ONE, What's your name?"
    play1_name = gets.chomp
    puts "PLAYER ONE, What's your mark?"
    play1_mark = gets.chomp
    puts "PLAYER TWO, What's your name?"
    play2_name = gets.chomp
    puts "PLAYER TWO, What's your mark?"
    play2_mark = gets.chomp
    @current_player = Player.new({:name => play1_name, :mark => play1_mark})
    @other_player = Player.new({:name => play2_name, :mark => play2_mark})
  end

  def get_input
      puts "Which row would you like to place a counter?"
      print "=>"
      @row = gets.chomp.to_i
      puts "Which column would you like to place a counter?"
      print "=>"
      @column = gets.chomp.to_i
      if !((1..3).include?@row) || !((1..3).include?@column)
        puts "You aint making sense, try again"
        get_input
      end
      if @board.grid[@row-1][@column-1].mark != @board.grid[@row-1][@column-1].default_mark
        puts "Try again, that spots taken!"
        get_input
      end
  end



  def play
    first_loop = true
    while true
      puts "#{@current_player.name}'s turn! (You're counter is #{@current_player.mark})"
      @board.show if first_loop
      first_loop = false
      get_input
      @board.mark_cell(@row, @column, @current_player.mark)
      @board.show
      if won?
        puts "ZOMG #{@current_player.name.upcase} YOU WON!! That other foo' #{@other_player.name} didn't have a chance!"
        break
      end
      if draw?
        puts "Is your name 'Da Vinci?', 'cause boy do you know how to draw!"
        break
      end
      switch_players
    end
    puts "Wanna go again? Y/N"
    play_again = gets.chomp.downcase
    if play_again == "y"
      @board = Board.new
      play
    else
       puts "No worries, see you next time!"
     end
  end

  def translate_command_to_board(command)
    #Give it a number, translate that number to row and column send to the board the row, column and current player.mark... % to give column, divide to give row
    # x_val=position%3-1
    # y_val=(position-1)/3

  end

  def current_player
    @players[0]
  end

  def switch_players
    @current_player, @other_player = @other_player, @current_player
  end

  def won?

    winning_combination = Array.new(3) {@current_player.mark}

    (0..2).each do |row|
      return true if @board.grid[row].map { |cell| cell.mark } == winning_combination
    end

    (0..2).each do |column|
      result = []
      @board.grid.each {|row| result << row[column].mark}
      return true if result == winning_combination
    end

    top_left_diagonal =[@board.grid[0][0].mark, @board.grid[1][1].mark, @board.grid[2][2].mark]

    top_right_diagonal = [@board.grid[0][2].mark, @board.grid[1][1].mark, @board.grid[2][0].mark]

    return true if top_left_diagonal == winning_combination || top_right_diagonal == winning_combination

    false
  end

  def draw?
    @board.grid.flatten.all? { |cell| cell.mark != cell.default_mark }
  end

end

 game = Game.new()
 game.play

