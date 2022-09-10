
alphabet = {}
('a'..'z').each_with_index do |char, i|
    if 'aeiouy'.include? char
        alphabet[char.to_sym] = i + 1
    end
end

puts alphabet