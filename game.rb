#!/usr/bin/ruby

require 'yaml'
require_relative 'Board'
require_relative 'Cell'
require_relative 'Player'

#----------------
# GAME
#----------------

class Game

  def initialize()
    want_to_load_existing_game
    user_create_players
    @current_player, @other_player = [@current_player, @other_player].shuffle
  end

    def play
    @board = Board.new
    first_loop = true
    while true
      puts "#{@current_player.name}'s turn! (You're counter is #{@current_player.mark})"
      if first_loop
        puts "If at anytime you'd like to save or load a game, simply type 'save' or 'load'!"
        @board.show
      end
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
       exit
     end
  end

  def prompt
    print "=>"
  end

  private

  def want_to_load_existing_game
     puts "If you'd like to load a game type 'load' and hit return, else press any key and return to continue!"
     print "=>"
     wishes_to_load = gets.chomp.downcase
     return load_game if wishes_to_load == 'load'
     puts "OK, great! Let's get down to business!"
  end

  def user_create_players
     @current_player = Player.new()
     @other_player = Player.new()
  end

  def get_input
      puts "Which row would you like to place a counter?"
      prompt
      @row = gets.chomp
      return save_game if @row== "save"
      return load_game if @row == "load"
      puts "Which column would you like to place a counter?"
      prompt
      @column = gets.chomp
      return save_game if @column == "save"
      return load_game if @column == "load"
      @row = @row.to_i
      @column = @column.to_i
      if !((1..3).include?@row) || !((1..3).include?@column)
        puts "You aint making sense, try again"
        get_input
      end
      if @board.grid[@row-1][@column-1].mark != @board.grid[@row-1][@column-1].default_mark
        puts "Try again, that spots taken!"
        get_input
      end
  end

  # Why can i not create a prompt variable?

  def save_game
    save_data = YAML::dump(self)
    puts "Please enter a name for your save game:"
    prompt
    @filename = gets.chomp
    File.open("./saved/#{@filename}", "w") { |file| file.write(save_data)}
    puts "Saved"
    get_input
  end

  def load_game
    saved_games = Dir["./saved/*"]
    saved_games.each_with_index { |file, index| puts "#{index+1}. #{file[8..-1]}"}
    puts "Enter the number of the game you would like to load:"
    prompt
    file_to_load = gets.chomp.to_i
    file_to_load = saved_games[file_to_load-1]
    loaded_data = ""
    File.open("#{file_to_load}", "r") { |file| loaded_data =file.read}
    loaded_game = YAML::load(loaded_data)
    loaded_game.play
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

