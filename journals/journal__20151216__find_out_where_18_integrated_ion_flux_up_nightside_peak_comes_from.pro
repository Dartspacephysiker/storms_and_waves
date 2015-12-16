;2015/12/16
;It's too tantalizing. Where on earth is this peak coming from?
PRO JOURNAL__20151216__FIND_OUT_WHERE_18_INTEGRATED_ION_FLUX_UP_NIGHTSIDE_PEAK_COMES_FROM

  HEMI   = 'North'
  minVal = 1e11
  
  LOAD_MAXIMUS_AND_CDBTIME,maximus
  
  good_i = GET_CHASTON_IND(maximus,/NIGHTSIDE,HEMI=hemi)
  
  high_i = CGSETINTERSECTION(WHERE(maximus.(18) GE minVal),good_i)
  low_i = CGSETINTERSECTION(WHERE(maximus.(18) LT minVal),good_i)

  PRINT,FORMAT='("N elements above ", G10.2,": ",I0)',minVal,N_ELEMENTS(high_i)
  PRINT,FORMAT='("N elements below ", G10.2,": ",I0)',minVal,N_ELEMENTS(low_i)
  
  ;;An altitude thing?
  cghistoplot,maximus.alt(high_i)
  cghistoplot,maximus.alt(low_i)

  ;;An MLT thing?
  cghistoplot,maximus.mlt(high_i)
  cghistoplot,maximus.mlt(low_i)

  ;;A season thing?
  cghistoplot,str_to_time(maximus.time(high_i))
  cghistoplot,str_to_time(maximus.time(low_i))

  ;;An orbit thing?
  cghistoplot,maximus.orbit(high_i)
  cghistoplot,maximus.orbit(low_i)

  months  = FIX(STRMID(maximus.time[good_i],5,2))

  ;; The preference is for 
  dec_i   = good_i[WHERE(months EQ 12)]
  cghistoplot,str_to_time(maximus.time[dec_i])
  cghistoplot,maximus.ilat[dec_i]
  cghistoplot,maximus.mlt[dec_i]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Weird

  ;;A whole lot of these occurred during December
  n_elements(cgsetintersection(dec_i,high_i))
  n_elements(high_i)

  ;;... Pre-dawn ...
  cghistoplot,maximus.mlt[dec_i]

  ;;... In 1999 ...
  cghistoplot,str_to_time(maximus.time[dec_i])
  
  ;;... At low latitudes ...
  cghistoplot,maximus.ilat[dec_i]

  cghistoplot,ALOG10(maximus.integ_ion_flux_up[dec_i])
  cghistoplot,ALOG10(maximus.eflux_losscone_integ[dec_i])

  ;; seasons = MAKE_ARRAY(N_ELEMENTS(maximus.time),/INTEGER)
   ;; FOR i=0,N_ELEMENTS(maximus.time) DO BEGIN

      
   ;; ENDFOR

END