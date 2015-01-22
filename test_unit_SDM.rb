#!/usr/bin/env ruby
require 'test/unit'
require_relative 'lib/SDM'

#Take 4 numbers generated randomly that follow a normal distribution, rnorm(4, mean=10, sd=2)

# hash = {11.374979=>["a"], 11.842904=>["b"], 10.120768=>["c"], 5.022447=>["d", "e", "f"]}

class TestSDM < Test::Unit::TestCase
	def setup 
		@dic_hm_inv = {11.374979=>["a"], 11.842904=>["b"], 10.120768=>["c"], 5.022447=>["d", "e", "f"]}
	end
	def test_sorting
		perm = SDM::sorting(@dic_hm_inv)
		assert_equal(["e", "d", "a", "b", "c", "f"], perm)
	end
end 

