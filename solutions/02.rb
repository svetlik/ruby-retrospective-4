class NumberSet
  include Enumerable
  def initialize
    @numbers = []
  end

  def each &block
    @numbers.each do |number|
      if block_given?
        block.call number
      else
        yield number
      end
    end
  end

  def <<(new_number)
                # Rational numbers preservation?
    if !(new_number.is_a? Numeric) or @numbers.include? new_number
      @numbers
    else
      @numbers.push(new_number)
      @numbers
    end
  end

  def size
    each { |number| number = 1 }
      .reduce(0) { |number| number = number + 1 }
  end

  def empty?
    size > 0 ? false : true
  end

  def [](filter_type)
    result = NumberSet.new
    result = filter_type.extract(self)
  end
end

class Filter
  def initialize(&block)
    @block = block
  end

  def extract(elements)
    result = []
    elements.each { |number| result << number if number == yield(number) }
  end

  def &(filter)
    and_filter = -> { proc.call(self) && proc.call(filter) }
  end

  def |(filter)
    or_filter = -> { proc.call(self) || proc.call(filter) }
  end
end

class TypeFilter < Filter
  def initialize(type)
    @type = type
  end

  def determine_type
    result = []
    case @type
    when :integer then result = ['Fixnum']
    when :real then result = ['Float', 'Rational']
    when :complex then result = ['Complex']
    end
    result
  end

  def extract(elements)
    result = []
    elements.each do |number|
      result << number if determine_type.include? number.class.to_s
    end
    result
  end
end

class SignFilter < Filter
  def initialize(sign)
    @sign = sign
  end

  def determine_sign
    plus_infinity = 1.0 / 0.0
    minus_infinity = -1.0 / 0.0
    case @sign
    when :positive then result = (0...plus_infinity)
    when :non_positive then result = (minus_infinity..0)
    when :negative then result = (minus_infinity...0)
    when :non_negative then result = (0..plus_infinity)
    end
    result
  end

  def extract(elements)
    result = []
    elements.each do |number|
      result << number if determine_sign.include? number
    end
    result
  end
end