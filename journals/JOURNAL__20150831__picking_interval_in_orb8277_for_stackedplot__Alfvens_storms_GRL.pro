;From fa_k0_dcf_08277_on.gif, it looks like 1998-09-25/2:
PRO JOURNAL__20150831__picking_interval_in_orb8277_for_stackedplot__Alfvens_storms_GRL


load_maximus_and_cdbtime,maximus,cdbtime

print,n_elements(where(maximus.orbit EQ 8277 AND maximus.sample_t LE 0.01 AND maximus.mlt GT 21))
print,maximus.ilat(where(maximus.orbit EQ 8277 AND maximus.sample_t LE 0.01 AND maximus.mlt GT 21))
print,maximus.time(where(maximus.orbit EQ 8277 AND maximus.sample_t LE 0.01 AND maximus.mlt GT 21))

;now some delta_B restrictions
print,maximus.time(where(maximus.orbit EQ 8277 AND maximus.sample_t LE 0.01 AND maximus.mlt GT 21 AND maximus.delta_b GT 15))

print,maximus.delta_e(where(maximus.orbit EQ 8277 AND maximus.sample_t LE 0.01 AND maximus.mlt GT 21 AND maximus.delta_b GT 30))
print,maximus.time(where(maximus.orbit EQ 8277 AND maximus.sample_t LE 0.01 AND maximus.mlt GT 21 AND maximus.delta_b GT 30))
;;Let's take 1998-09-25/02:46:30 through 1998-09-25/02:48:25, which picks up three big events

;;Actual event times
;; t1='1998-09-25/02:46:33.653'
;; t2='1998-09-25/02:48:22.067'

t1='1998-09-25/02:46:30'
t2='1998-09-25/02:48:25'

END