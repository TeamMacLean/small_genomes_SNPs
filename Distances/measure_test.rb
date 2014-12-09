
require 'test/unit'
require_relative 'measure.rb'

class MeasureTest < Test::Unit::TestCase

	def setup
		@original = [1,2,3,4,5]
		@perm = [5,3,1,4,2]

		@even_original = [1,2,3,4,5,6,7,8,9,10]
		@even_perm = [5,3,1,4,2,8,9,10,7,6]
		@odd_original = [1,2,3,4,5,6,7,8,9]
		@odd_perm = [5,3,1,4,2,8,9,7,6]
	end

	def test_top_and_tail
		original, trimmed = Measure.top_and_tail(@original, @perm)
		assert_equal([1,3,4], @original)
		assert_equal([3,1,4], @perm)
	end

	def test_square
		##test for even length perms

		distances = Measure.square(@even_original, @even_perm)
		assert_equal([0.13095238095238093, 0.02857142857142857, 0.1, 0.0], distances)
	end

	def test_square
		##test for odd length perms
		distances = Measure.square(@odd_original, @odd_perm)
		assert_equal([0.14285714285714285, 0.05, 0.25], distances)
	end

end
