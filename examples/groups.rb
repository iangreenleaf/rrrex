$: << File.join(File.expand_path(File.dirname(__FILE__)), "..", "lib/") 
require 'rrrex'

#named groups!
p "powertiger".rmatch? { 
  "power" + group(:animal_name, (1.or_more letter))
}[:animal_name] # => tiger 

#named groups are also accessable via their number, for your convenience
p "powersnail".rmatch? { 
  "power" + group(:animal_name, (1.or_more letter))
}[1] # => snail

p "aaabc".rmatch? { group(1.or_more "a") }[1]
p "aaabc".rmatch? { group(:alpha, (1.or_more "a")) }[:alpha]
