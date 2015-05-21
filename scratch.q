parseTime:{
	s:string x;
	m:1 _ -3 # string x;
	v:"V"$-3 _ string x;
	$[m~"PM";v:v+12:00:00;];
 v}
parseTimes:{
 {parseTime x} each x}