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
     ''                 using 1:4 w linesp lw 1.5 lt 2 ti "dead",\


set ytics 0,250
set out "plots/scotland-confirmed-linear.png"
plot 'data/scotland.gp' using 1:3 w linesp lw 1.5 lt 1 ti "confirmed positive",\
     ''                 using 1:4 w linesp lw 1.5 lt 2 ti "dead"



set logscale y
set ytics 0,100
set yrange [*:*]
set ylabel "confirmed cases (logscale)"

set out "plots/scotland-tested.png"
plot 'data/scotland.gp' using 1:2 w linesp lw 1.5 lt 3 ti "tested",\
     ''                 using 1:3 w linesp lw 1.5 lt 1 ti "confirmed positive",\
     ''                 using 1:4 w linesp lw 1.5 lt 2 ti "dead",\

set out "plots/scotland-confirmed.png"
plot 'data/scotland.gp' using 1:3 w linesp lw 1.5 lt 1 ti "confirmed positive",\
     ''                 using 1:4 w linesp lw 1.5 lt 2 ti "dead"

EOF

