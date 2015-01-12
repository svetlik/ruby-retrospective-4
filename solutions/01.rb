def series(name, index)
  case name
    when 'fibonacci'  then generic_series(1, 1, index)
    when 'lucas'      then generic_series(2, 1, index)
    when 'summed'     then series('fibonacci', index) + series('lucas', index)
  end
end

def generic_series(first_element, second_element, index)
  return first_element  if index == 1
  return second_element if index == 2

  generic_series(first_element, second_element, index - 1) +
  generic_series(first_element, second_element, index - 2)
end
