;2016/08/24
;This little beaut checks for gaps in Dst before proceeding. You should be OK.
PRO ADD_SMOOTHED_DST_AND_DST_DERIVATIVE_TO_FULLMONTY_DST_STRUCT

  ;; smoothedFile= 'idl_ae_dst_data--smoothed.dat'
  smoothedFile     = 'idl_dst_data--1957-2011--smoothed_w_deriv.dat'
  outDir           = '/SPENCEdata/Research/database/storm_data/processed/'

  inDir            = '/SPENCEdata/Research/database/storm_data/'
  inData           = 'dst_1957-2011.sav'
  RESTORE,inDir+inData
  ;; LOAD_DST_AE_DBS,dst,/FULL_DST_DB, $
  ;;                 DST_AE_DIR=dst_AE_dir,DST_AE_FILE=dst_AE_file

  ;;A little test for you to see that things came out OK
  PRINT,'Checking to make sure time series is monotonic and increments by one hour ...'
  diff             = ROUND(((SHIFT(dst.julday,-1)-dst.julday)[0:-2])*24.)
  IF (WHERE(diff NE 1))[0] NE -1 THEN BEGIN
     PRINT,'Your time series is off, and your derivative will be junk.'
     STOP
  ENDIF ELSE BEGIN
     PRINT,'Check the julDay time series, and it appears Dst data increments by one hour from 1957 to 2011! Good to go.'
     PRINT,MAX(diff)
     PRINT,MIN(diff)
  ENDELSE

  ;;Let's smooth Dst first
  dst_smoothed_6hr = SMOOTH(dst.dst,6,/EDGE_TRUNCATE)

  ;;These look good
  ;; dstplot=plot(dst.dst[100:199])  
  ;; dstsmoothplot=plot(dst_smooth6hr[100:199])

  ;; dt_dst_sm6hr = SHIFT(dst_smoothed_6hr,-1)-dst_smoothed_6hr

  dt_dst_sm6hr     = DERIV(dst_smoothed_6hr)

  dst_sm_str       = "Smoothing is performed using 6 Dst points, and dt_dst_sm6hr is obtained with the DERIV procedure. See the pro ADD_SMOOTHED_DST_AE_AND_DST_AE_DERIVATIVE_TO_DST_AE_STRUCTS to learn more."

  dst              = {date:dst.date, $
                      ;; time:dst.time, $
                      julday:dst.julday, $
                      doy:dst.doy, $
                      dst:dst.dst, $
                      dst_smoothed_6hr:dst_smoothed_6hr, $
                      dt_dst_sm6hr:dt_dst_sm6hr, $
                      info:dst_sm_str}

  PRINT,'Saving fancy, new, smoothed, buttered, dolloped, Dst DB to ' + smoothedFile
  SAVE,dst,FILENAME=outDir+smoothedFile

END