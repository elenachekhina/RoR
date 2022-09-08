puts "Enter first side:"
a = gets.chomp.to_i
puts "Enter second side:"
b = gets.chomp.to_i
puts "Enter third side:"
c = gets.chomp.to_i

if a == b && b == c
    puts "Triangle is equilateral"
elsif a == b || b == c || c == a
    puts "Triangle is isosceles"
end

if (a > b && a > c && (a**2 == b**2 + c**2)) || (b > a && b > c && (b**2 == a**2 + c**2)) || (c > b && c > a && (c**2 == b**2 + a**2))
    puts "Triangle is rectangular"
end

