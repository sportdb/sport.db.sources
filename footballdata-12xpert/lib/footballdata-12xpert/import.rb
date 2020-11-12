module Footballdata12xpert


def self.import( *country_keys, start: nil )
  ## note: always downcase and symbolize keys (thus, allow strings too for now)
  country_keys = country_keys.map {|key| key.downcase.to_sym }

  ## fix/todo:  filter by country keys and start sesason to be (re)done

  ## todo/fix:  use/add normalize: true  option!!!!!

  dir = File.expand_path( config.convert.out_dir )
  puts "  dir: >#{dir}<"

  # SportDb.read_csv( dir )
  ##  todo/fix: use SportDb Csv Package or such???
  puts "import to be (re)done; sorry"
end # method import


end ## module Footballdata12xpert
