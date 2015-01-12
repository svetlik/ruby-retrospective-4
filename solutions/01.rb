def series(name, index)
  case name
    when 'fibonacci' then calculate_member(1, 1, index)
    when 'lucas' then calculate_member(2, 1, index)
    when 'summed' then series('fibonacci', index) + series('lucas', index)
  end
end

def calculate_member(first_element, second_element, index)
  sequence = [nil, first_element, second_element]
  (3..index).each do |element|
    sequence[element] = sequence[element - 2] + sequence[element - 1]
  end
  sequence[index]
end
