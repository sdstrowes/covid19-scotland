#!/bin/bash

gnuplot <<EOF

set term pngcairo size 1000,500

set title "data from https://www.gov.scot/coronavirus-covid-19/"

set key top left

set border 3
set grid
set tics nomirror

set ylabel "confirmed cases"

set xdata time
set timefmt "%Y-%m-%d"
set format x "%Y-%m-%d"

set xtic rotate

set yrange [0:*]
set xrange [1583020800:*]

set out "plots/scotland-tested-linear.png"
plot 'data/scotland.gp' using 1:2 w linesp lw 1.5 lt 3 ti "tested",\
     ''                 using 1:3 w linesp lw 1.5 lt 1 ti "confirmed positive",\
     ''                 using 1:4 w linesp lw 1.5 lt 2 ti "attributed deaths",\


set ytics 0,500
set out "plots/scotland-confirmed-linear.png"
plot 'data/scotland.gp' using 1:3 w linesp lw 1.5 lt 1 ti "confirmed positive",\
     ''                 using 1:4 w linesp lw 1.5 lt 2 ti "attributed deaths"



set logscale y
set ytics 0,100
set yrange [*:*]
set ylabel "confirmed cases (logscale)"

set out "plots/scotland-tested.png"
plot 'data/scotland.gp' using 1:2 w linesp lw 1.5 lt 3 ti "tested",\
     ''                 using 1:3 w linesp lw 1.5 lt 1 ti "confirmed positive",\
     ''                 using 1:4 w linesp lw 1.5 lt 2 ti "attributed deaths",\

set out "plots/scotland-confirmed.png"
plot 'data/scotland.gp' using 1:3 w linesp lw 1.5 lt 1 ti "confirmed positive",\
     ''                 using 1:4 w linesp lw 1.5 lt 2 ti "attributed deaths"


unset logscale y
set yrange [0:*]

set title "Data from https://www.gov.scot/publications/trends-in-number-of-people-in-hospital-with-confirmed-or-suspected-covid-19/"

set out "plots/scotland-hospital.png"
plot 'data/scotland.gp' using 1:10 w linesp lw 1.5 lt 7 ti "total",\
     ''                 using 1:9  w linesp lw 1.5 lt 5 ti "suspected COVID-19",\
     ''                 using 1:8  w linesp lw 1.5 lt 6 ti "confirmed positive",\

set out "plots/scotland-icu.png"
plot 'data/scotland.gp' using 1:7  w linesp lw 1.5 lt 7 ti "total",\
     ''                 using 1:6  w linesp lw 1.5 lt 5 ti "suspected COVID-19",\
     ''                 using 1:5  w linesp lw 1.5 lt 6 ti "confirmed positive",\

EOF

