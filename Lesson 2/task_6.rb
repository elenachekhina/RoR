puts "Product - price - number"
basket = Hash.new({})
loop do
    input = gets.chomp.split('-')
    product = input[0].split.join(' ').downcase
    
    break if product == 'stop'

    price = input[1].split.join.strip.gsub(',', '.').to_f
    number = input[2].split.join.strip.gsub(',', '.').to_f

    if basket.include? product
        if basket[product].include? price
            basket[product][price] += number
        else
            basket[product][price] = number
        end
    else
        basket[product] = {price => number}
    end
end

final_price = 0
basket.each do |product, price_num|
    final_array = ["Product: #{product}"]
    total = 0
    price_num.each do |price, number|
        total += price * number
        final_array << "price: #{price} - num: #{number}"
    end
    final_array << "Total: #{total}"
    final_price += total
    puts final_array.join(' | ')
end
puts "Final price = #{final_price}"