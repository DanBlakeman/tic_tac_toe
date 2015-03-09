#----------------
# PLAYER
#----------------

class Player

  attr_reader :mark, :name

  @@player_count = 0

  def initialize()
    @@player_count += 1
    user_create_player
  end

  def user_create_player
    puts "PLAYER #{@@player_count}, What's your name?"
    player_name = gets.chomp
    puts "PLAYER #{@@player_count}, What's your mark?"
    player_mark = gets.chomp
    while player_mark.length > 2 || player_mark.length < 1
      puts "A mark must be either one or two characters long! Please enter a new mark:"
      player_mark = gets.chomp
    end
    player_mark = " "+player_mark if player_mark.length < 2
    @mark = player_mark
    @name = player_name
  end
end