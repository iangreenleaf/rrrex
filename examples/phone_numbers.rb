$: << File.join(File.expand_path(File.dirname(__FILE__)), "..", "lib/") 
require 'rrrex'

#something that looks like telephone numbers
phonenumbers = [
  "(123) 456-7890",
  "(123)456-7890",
  "123-456-7890",
  "(123) 456 7890",
  "123.456.7890",
  "1234567890",
  "123456-7890",
  "123 456 7890"
  ]

phonenumbers.each {|number|

number = number.rmatch?{ 
   group(:area_code, (3.exactly digit)) + 
   (0.or_more any_char) +
   group(:prefix, (3.exactly digit)) +
   (0.or_more any_char) +
   group(:line_number, (4.exactly digit))

   }
p "#{number[:area_code]}.#{number[:prefix]}.#{number[:line_number]}" if number
}

