#----------------
# CELL
#----------------

class Cell

  attr_accessor :mark, :default_mark

  def initialize(empty_cell_mark = "  ")
    @mark = empty_cell_mark
    @default_mark = empty_cell_mark
  end

end
