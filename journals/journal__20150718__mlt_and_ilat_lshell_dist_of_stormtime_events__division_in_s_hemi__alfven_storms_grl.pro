;2015/07/18
; It occurs to me, upon considering the ILAT distribution in the southern hemisphere, that there may be some correspondence
; between the lumps of events at higher ILATs and nearer noon and events at lower lats and events that are
;pre-midnight. It's just a hunch, but we'll see…

;All those storms
dataDir='/SPENCEdata/Research/database/'
;; restore,'superposed_largestorms_-15_to_5_hours.dat'
restore,'superposed_large_storm_output_w_n_Alfven_events--arreglado--HEAVILY_PARED--neg5_to_20hours--20150701.dat'

largeStorm_ind=tot_plot_i_list(0)
FOR i=1,N_ELEMENTS(tot_plot_i_list)-1 DO largeStorm_ind=[largeStorm_ind,tot_plot_i_list(i)]

restore,'../database/dartdb/saves/Dartdb_20150611--500-16361_inc_lower_lats--maximus.sav'

pos=[0.15,0.15,0.95,0.925] ;Position of histos in window

;**************************************************
;For overlaid plots

;; xRange_lShell=[0,40]
xRange_MLT=[0,24]
;; xRange_ILAT=[50,90]

yRange_MLT_ILAT=[0,0.25]
;; yRange_lShell=[0.,0.15]

;; binSize_lShell=1
;; binSize_ILAT=2
binSize_MLT=1
;**************************************************
;good_i
good_i_all=get_chaston_ind(maximus,'OMNI',-1,CHARERANGE=[4,6000],/BOTH_HEMIS)
good_i_south=get_chaston_ind(maximus,'OMNI',-1,CHARERANGE=[4,6000],/SOUTH)
good_i_north=get_chaston_ind(maximus,'OMNI',-1,CHARERANGE=[4,6000],/NORTH)

;**************************************************
;overlay the two MLT plots
;just northern
data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat GT 0))
data_1=maximus.mlt(data_1_ind)

data_2_ind=cgsetdifference(good_i_north,largeStorm_ind)
data_2=maximus.mlt(data_2_ind)

data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
;; data_2_title='All events: ' + STRCOMPRESS(N_ELEMENTS(good_i_north),/REMOVE_ALL)
data_2_title='Non-storm: ' + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)

histTitle='Relative freq. of activity, Northern'

outFile='MLT--Northern--largeStorms_below_73deg_ILAT--HEAVILY_PARED--overlaid_w_all_events.png'

OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
                   DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
                   BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
                   OUTFILE=outFile,POS=pos

;just southern, above 73
data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(ABS(maximus.ilat) GT 73 AND maximus.ilat LT 0))
data_1=maximus.mlt(data_1_ind)

data_2_ind=cgsetdifference(good_i_south,largeStorm_ind)
data_2=maximus.mlt(data_2_ind)

data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
;; data_2_title='All events: ' + STRCOMPRESS(N_ELEMENTS(good_i_south),/REMOVE_ALL)
data_2_title='Non-storm: ' + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)

histTitle='Relative freq. of activity, Southern'

outFile='MLT--Southern--largeStorms_split_above_73deg_ILAT--HEAVILY_PARED--overlaid_w_all_events.png'
OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
                   DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
                   BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
                   OUTFILE=outFile,POS=pos

;;just southern, below 73
data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(ABS(maximus.ilat) LE 73 AND maximus.ilat LT 0))
data_1=maximus.mlt(data_1_ind)

data_2_ind=cgsetdifference(good_i_south,largeStorm_ind)
data_2=maximus.mlt(data_2_ind)

data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
;; data_2_title='All events: ' + STRCOMPRESS(N_ELEMENTS(good_i_south),/REMOVE_ALL)
data_2_title='Non-storm: ' + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)

histTitle='Relative freq. of activity, Southern'

outFile='MLT--Southern--largeStorms_split_below_73deg_ILAT--HEAVILY_PARED--overlaid_w_all_events.png'
OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
                   DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
                   BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
                   OUTFILE=outFile,POS=pos


;**************************************************
;overlay two L-SHELL plots

;; data_1_ind=largeStorm_ind
;; data_1=lShell(data_1_ind)

;; data_2_ind=cgsetdifference(good_i_all,largeStorm_ind)
;; data_2=lShell(data_2_ind)

;; data_1_col='yellow'
;; data_2_col='olive'

;; data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
;; data_2_title='Non-storm: ' + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)

;; histTitle='Relative freq. of activity'

;; binsize=binSize_lShell
;; ;; XRANGE=[-90,90]
;; XRANGE=xRange_lShell
;; yRange=yRange_lShell
;; xTitle='L-SHELL'
;; outFile='L-SHELL--largeStorms_below_73deg_ILAT--HEAVILY_PARED--overlaid_w_all_events.png'

;; OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
;;                    DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
;;                    BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
;;                    OUTFILE=outFile,POS=pos


;; ;just northern
;; data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat GT 0))
;; data_1=lShell(data_1_ind)

;; data_2_ind=cgsetdifference(good_i_north,largeStorm_ind)
;; data_2=lShell(data_2_ind)

;; data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
;; data_2_title='Non-storm: ' + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)
;; ;; xRange=[50,90]
;; xRange=xRange_lShell
;; histTitle='Relative freq. of activity, Northern'

;; outFile='L-SHELL--Northern--largeStorms_below_73deg_ILAT--HEAVILY_PARED--overlaid_w_all_events.png'

;; OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
;;                    DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
;;                    BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
;;                    OUTFILE=outFile,POS=pos

;; ;just southern
;; data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat LT 0))
;; data_1=lShell(data_1_ind)

;; data_2_ind=cgsetdifference(good_i_south,largeStorm_ind)
;; data_2=lShell(data_2_ind)

;; data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
;; data_2_title='Non-storm: ' + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)
;; xRange=xRange_lShell
;; ;; xRange=[-90,-50]
;; histTitle='Relative freq. of activity, Southern'

;; outFile='L-SHELL--Southern--largeStorms_below_73deg_ILAT--HEAVILY_PARED--overlaid_w_all_events.png'
;; OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
;;                    DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
;;                    BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
;;                    OUTFILE=outFile,POS=pos


;**************************************************
;;overlay two ILAT plots

;; data_1_ind=largeStorm_ind
;; data_1=maximus.ilat(data_1_ind)

;; data_2_ind=cgsetdifference(good_i_all,largeStorm_ind)
;; data_2=maximus.ilat(data_2_ind)

;; data_1_col='yellow'
;; data_2_col='olive'

;; data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
;; data_2_title='Non-storm: ' + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)

;; histTitle='Relative freq. of activity'

;; binsize=binSize_ILAT
;; XRANGE=[-xRange_ILAT[1],xRange_ILAT[1]]
;; yRange=yRange_MLT_ILAT
;; xTitle='ILAT'
;; outFile='ILAT--largeStorms_below_73deg_ILAT--HEAVILY_PARED--overlaid_w_all_events.png'

;; OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
;;                    DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
;;                    BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
;;                    OUTFILE=outFile,POS=pos


;;just northern
;; data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat GT 0))
;; data_1=maximus.ilat(data_1_ind)

;; data_2_ind=cgsetdifference(good_i_north,largeStorm_ind)
;; data_2=maximus.ilat(data_2_ind)

;; data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
;; data_2_title='Non-storm: ' + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)
;; XRANGE=xRange_ILAT
;; histTitle='Relative freq. of activity, Northern'

;; outFile='ILAT--Northern--largeStorms_below_73deg_ILAT--HEAVILY_PARED--overlaid_w_all_events.png'

;; OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
;;                    DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
;;                    BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
;;                    OUTFILE=outFile,POS=pos

;;just southern
;; data_1_ind=CGSETINTERSECTION(largeStorm_ind,WHERE(maximus.ilat LT 0))
;; data_1=maximus.ilat(data_1_ind)

;; data_2_ind=cgsetdifference(good_i_south,largeStorm_ind)
;; data_2=maximus.ilat(data_2_ind)

;; data_1_title='Large storms: ' + STRCOMPRESS(N_ELEMENTS(data_1_ind),/REMOVE_ALL)
;; data_2_title='Non-storm: ' + STRCOMPRESS(N_ELEMENTS(data_2_ind),/REMOVE_ALL)
;; xRange=-REVERSE(xRange_ILAT)
;; histTitle='Relative freq. of activity, Southern'

;; outFile='ILAT--Southern--largeStorms_below_73deg_ILAT--HEAVILY_PARED--overlaid_w_all_events.png'
;; OVERLAY_TWO_HISTOS,data_1,data_2,DATA_1_COL=data_1_col,DATA_2_COL=data_2_col, $
;;                    DATA_1_TITLE=data_1_title,DATA_2_TITLE=data_2_title, $
;;                    BINSIZE=binSize,XRANGE=xRange,YRANGE=yRange,HISTTITLE=histTitle,XTITLE=xTitle, $
;;                    OUTFILE=outFile,POS=pos
