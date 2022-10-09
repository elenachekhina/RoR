puts "ax^2 + bx + c = 0"
puts "Enter a:"
a = gets.chomp.to_i
puts "Enter b:"
b = gets.chomp.to_i
puts "Enter c:"
c = gets.chomp.to_i

d = b**2 - 4*a*c
puts "D = #{d}"
if d > 0
    puts "x1 = #{(-b + Math.sqrt(d)) / 2 * a}; x2 = #{(-b - Math.sqrt(d)) / 2 * a}"
elsif d == 0
    puts "x1 = #{(-b) / 2 * a}"
else
    puts "There're no roots"
end

# Нет случая, когда a = 0. В задании не написано его обрабатывать. Формально при a = 0 это даже не квадратное уравнение