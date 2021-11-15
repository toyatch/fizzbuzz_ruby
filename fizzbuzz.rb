module FizzBuzz
end

class FizzBuzz::Simple
  def fizzbuzz_string(value)
    return "FizzBuzz" if value % 3 == 0 && value % 5 == 0
    return "Fizz" if value % 3  == 0
    return "Buzz" if value % 5  == 0
    value.to_s
  end
  def fizzbuzz
    (1..15).map { |n| fizzbuzz_string(n) }
  end
end

class FizzBuzz::ValueObject
  class FizzBuzzString
    def initialize(value)
      if value % 3 == 0 && value % 5 == 0
        @value = "FizzBuzz"
      elsif value % 3  == 0
        @value = "Fizz"
      elsif value % 5  == 0
        @value = "Buzz"
      else
        @value = value.to_s
      end
    end
    def to_s
      @value
    end
  end
  def fizzbuzz
    (1..15).map { |n| FizzBuzzString.new(n) }.map(&:to_s)
  end
end

class FizzBuzz::OpenClass
  module FizzbuzzableInteger
    refine Integer do
      def fizz?
        self % 3 == 0
      end
      def buzz?
        self % 5 == 0
      end
      def to_s
        return "FizzBuzz" if fizz? and buzz?
        return "Fizz" if fizz?
        return "Buzz" if buzz?
        super
      end
    end
  end
  using FizzbuzzableInteger

  def fizzbuzz
    (1..15).map(&:to_s)
  end
end

# tests

require 'minitest/autorun'

FizzBuzzTest = Class.new(Minitest::Test) do
  expected = [
    '1', '2', 'Fizz', '4', 'Buzz',
    'Fizz', '7', '8', 'Fizz', 'Buzz',
    '11', 'Fizz', '13', '14', 'FizzBuzz',
  ]
  FizzBuzz.constants.each_with_index do |klass, i|
    define_method("test_#{i}") do
      assert_equal expected, instance_eval("FizzBuzz::#{klass}.new.fizzbuzz")
    end
  end
end
