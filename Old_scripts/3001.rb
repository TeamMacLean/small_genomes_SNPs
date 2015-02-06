#encoding: utf-8
require 'pp'

dic_shuf_hm_norm = {"frag19"=>0.0, "frag26"=>0.2127659574468085}
# dic_shuf_hm_norm.delete_if {|key, value| value = 0.0 } 
pp dic_shuf_hm_norm.has_value? 0.0 