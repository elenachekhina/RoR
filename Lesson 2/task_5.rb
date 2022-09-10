monthes = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

puts "dd-mm-yyyy:"
date = gets.chomp
day = date[0..1].to_i
month = date[3..4].to_i
year = date[6..-1].to_i

is_leap = false

if year % 4 == 0
    if year % 100 == 0
        if year % 400 == 0
            is_leap = true
        end
    else
        is_leap = true
    end
end

if is_leap
    monthes[1] = 29
end

puts monthes[0...month-1].sum + day
