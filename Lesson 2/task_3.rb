arr = [1, 1]
while arr[-1] + arr[-2] < 100 do
    arr.push(arr[-1] + arr[-2])
end
puts arr