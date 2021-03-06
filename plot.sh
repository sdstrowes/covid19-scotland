#!/bin/bash

awk '
BEGIN {
	last_hosp = 0
	last_icu  = 0
}
{
	if (last_hosp == -1) {
		hosp = 0
		icu  = 0
	}
	else {
		if (NF > 10 && $8 == "-") {
			hosp = $11 - last_hosp
			last_hosp = $11
		}
		else if (NF > 4) {
			hosp = $8 - last_hosp
			last_hosp = $8
		}
		icu  = $5 - last_icu
		last_icu = $5
	}

	print $1, $3-last_positive, $4-last_deaths, hosp, icu

	last_positive = $3
	last_deaths = $4
}' data/scotland.gp > data/scotland-deltas.gp
enddate=$(gdate --date `tail -1 data/scotland-deltas.gp | awk '{print $1}'` -u +%s)

gnuplot <<EOF

set term pngcairo size 1000,500

set title "data from https://www.gov.scot/coronavirus-covid-19/"

set key top left

set grid
set tics nomirror

set ylabel "confirmed cases"

set xdata time
set timefmt "%Y-%m-%d"
set format x "%Y-%m-%d"

set xtic rotate

set yrange [0:*]
set xrange [1583020800:*]
set xtics 1583107200,604800

set border 11
set y2tics 0,0.02
set y2range [0:0.24]
set y2label "people tested to positive case ratio"
set out "plots/scotland-tested-linear.png"
plot 'data/scotland.gp' using 1:2 w linesp lw 1.5 lt 3 ti "people tested",\
     ''                 using 1:3 w linesp lw 1.5 lt 1 ti "confirmed positive",\
     ''                 using 1:4 w linesp lw 1.5 lt 2 ti "attributed deaths",\
     ''                 using 1:(\$3/\$2) w linesp lw 1 lt 7 ti "tested-to-positive ratio (y2)" axes x1y2 ,\

unset y2label
unset y2tics
set border 3
set ytics 0,10000
set ylabel "confirmed cases"
set out "plots/scotland-confirmed-linear.png"
plot 'data/scotland.gp' using 1:3 w linesp lw 1.5 lt 1 ti "confirmed positive",\
     ''                 using 1:4 w linesp lw 1.5 lt 2 ti "attributed deaths"



set logscale y
set ytics 0,100
set yrange [*:*]
set ylabel "confirmed cases (logscale)"

set out "plots/scotland-tested.png"
plot 'data/scotland.gp' using 1:2 w linesp lw 1.5 lt 3 ti "people tested",\
     ''                 using 1:3 w linesp lw 1.5 lt 1 ti "confirmed positive",\
     ''                 using 1:4 w linesp lw 1.5 lt 2 ti "attributed deaths",\

set out "plots/scotland-confirmed.png"
plot 'data/scotland.gp' using 1:3 w linesp lw 1.5 lt 1 ti "confirmed positive",\
     ''                 using 1:4 w linesp lw 1.5 lt 2 ti "attributed deaths"


unset logscale y
set yrange [0:*]

set title "Data from https://www.gov.scot/publications/trends-in-number-of-people-in-hospital-with-confirmed-or-suspected-covid-19/"
set ylabel "cases"

set out "plots/scotland-hospital.png"
set key top right
set title "Patients currently hospitalised"
plot 'data/scotland.gp' using 1:10 w linesp lw 1.5 lt 4 ti "total",\
     ''                 using 1:9  w linesp lw 1.5 lt 5 ti "suspected positive",\
     ''                 using 1:8  w linesp lw 1.5 lt 6 ti "confirmed positive (old measure)",\
     ''                 using 1:11 w linesp lw 1.5 lt 7 ti "recently confirmed positive",\

set ytics 0,50
set out "plots/scotland-icu.png"
set title "Patients currently in ICU or combined ICU/HDU"
plot 'data/scotland.gp' using 1:7  w linesp lw 1.5 lt 7 ti "total",\
     ''                 using 1:6  w linesp lw 1.5 lt 5 ti "suspected positive",\
     ''                 using 1:5  w linesp lw 1.5 lt 6 ti "confirmed positive",\



# ----------------------------------------------------------------------------------------------

set term pngcairo size 1000,800

set ylabel "daily change"
set yrange [0:2800]
set out "plots/scotland-change.png"
set multiplot title "Daily changes: number of new positive cases, reported deaths, hospitalised, and ICU"

set border 2
set xtic scale 0
set notitle
set format x ""
set arrow from 1583020800,0 to $enddate,0 nohead

set ytics -400,200

set size 0.5,0.43
set origin 0,0.53
plot 'data/scotland-deltas.gp' using 1:2 w imp lw 1.5 lt 1 ti "confirmed positive"

set origin 0.5,0.53
set yrange [0:100]
set ytics 0,10
plot 'data/scotland-deltas.gp'                        using 1:3 w imp lw 1.5 lt 2 ti "attributed deaths"

set format x "%Y-%m-%d"
#set tmargin at screen 0.1

set size 0.5,0.535
set origin 0,0

set yrange [-80:140]
set ytics -80,20

plot 'data/scotland-deltas.gp'                        using 1:4 w imp lw 1.5 lt 4 ti "hospitalised"

set origin 0.5,0
set yrange [-40:70]
set ytics -80,10
plot 'data/scotland-deltas.gp'                        using 1:5 w imp lw 1.5 lt 7 ti "ICU/HDU"
unset multiplot
EOF

