
module Rsssf

class Schedule

def self.from_string( txt )
  self.new( txt )
end

attr_accessor :rounds     # track no of rounds
  
def initialize( txt )
  @txt = txt
  
  @rounds = nil   # undefined
end


def save( path )
  write_text( path, @txt )
end

end  ## class Schedule
end  ## module Rsssf
