
module Rsssf

class Schedule


#  attr_accessor :rounds     # track no of rounds - why? why not?
  
def initialize( txt )
  @txt = txt
  
  ## @rounds = nil   # undefined
end


def save( path, header: )
  write_text( path, header + @txt )
end

end  ## class Schedule
end  ## module Rsssf
