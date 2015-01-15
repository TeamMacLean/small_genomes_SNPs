ls Gen*hyp.png | sort -k2 -tn -n > gif_loc_hyp.txt
convert @gif_loc_hyp.txt images_hyp.gif

ls Gen*hm.png | sort -k2 -tn -n > gif_loc_hm.txt
convert @gif_loc_hm.txt images_hm.gif