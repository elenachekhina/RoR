puts "What is your name?"
name = gets.chomp.downcase.capitalize
puts "What is your height?"
height = gets.chomp.to_i
ideal_weight = (height - 110) * 1.15
if ideal_weight > 0
    puts "#{name}, your ideal weight is #{ideal_weight}"
else
    puts "Your weight is already optimal"
end