// this example script creates a sortable 1MM row table

\p 5000

\l hypergrid-support.q

//turn on sorting
features[`sorting]:1b;

load `ticks
load `stocks