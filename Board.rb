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
      print "------------\n" unless row == grid.first
      print x.join(" | "), "\n"
    end
    print "\n"
  end


  private

  def default_grid
    Array.new(3) { Array.new(3) {Cell.new}}
  end

end