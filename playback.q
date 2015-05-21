\p 5000
\l stocks
\l ticks
\l hypergrid-support.q

trade:(`$ssr[;" ";"_"]each string cols stocks)xcol stocks

f:{t:`TICKER xcol select by Symbol from(x);
 `trade set trade lj update PnL:Change*Volume*floor(-0.0001;0f;0.0001)@count[t]?3 from t;
  pushUpdates[]}

COUNTER:0;
.z.ts:{
	f ticks til COUNTER;
	COUNTER::COUNTER+921;
	-1 string COUNTER;
	$[COUNTER > count ticks;COUNTER::0;];
 }

\t 300
