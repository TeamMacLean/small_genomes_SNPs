
#encoding: utf-8

require 'pp'

ok_hm = { "frag21"=>1.0, "frag22"=>2.0, "frag23"=>1.0}

hm_list = [100, 101, 102, 103]

class LO
	def self.positions_by_fragment(dic, snp_list)
		dic.each do |id, number| 
			if number.to_i > 0 
				dic.store(id, snp_list[0..(number.to_i-1)])
				(number.to_i).times do
		    		snp_list.delete_at(0)
				end
			end
		end
	end
end

ok_hm = LO.positions_by_fragment(ok_hm, hm_list)

pp ok_hm