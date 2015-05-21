\l stocks

parseTime:{
	s:string x;
	m:1 _ -3 # string x;
	v:"V"$-3 _ string x;
	$[m~"PM";v:v+12:00:00;];
 v}
parseTimes:{
 {parseTime x} each x}

query:"curl -u Mzy@opnf.in:Opnfin2015 http://batsrealtime.xignite.com/xBATSRealTime.csv/GetRealQuotesByIdentifiers\\?IdentifierType\\=Symbol\\&Identifiers\\=",1 _ raze {",",x} each string asc 1000 # exec TICKER from stocks;
grp:0;
result:system query;
headers:`Group,`$"," vs result 0;
data:{{(x 0) $ (x 1)} each flip (("SSSFSSDSFFFDFFFFFIFFFIIS"); ("," vs x))} each (1 _ result);
ticks:flip (headers!(enlist ((count data)# grp+:1)), flip data);
delete from `ticks where TradingHalted = `True;
delete Outcome,Message,Date,Time,Identity,Delay,TradingHalted from `ticks;
update DT:.z.Z from `ticks;
ticks: ()xkey select by Group,Symbol from ticks;

.z.ts:{
	result:system query;
	data:{{(x 0) $ (x 1)} each flip (("SSSFSSDSFFFDFFFFFIFFFIIS"); ("," vs x))} each (1 _ result);
	data:flip (headers!(enlist ((count data)# grp+:1)), flip data);

	data:delete from data where TradingHalted = `True;
	data:delete Outcome,Message,Date,Time,Identity,Delay,TradingHalted from data;
	data:update DT:.z.Z from data;
	data:()xkey select by Group,Symbol from data;
	ticks,:data;
	-1 string count ticks;
 }

//600000 rows seems to yield files of under 100MB
//requirement for github
saveTicks: {
	blockSize:600000;
	times: ceiling (count ticks) % blockSize;
	cuts:(til times),'((blockSize * til times),count ticks)({(0 1)+x}each (til times));
	{(`$":ticks",(string (10 + (x 0)))) 1: -8!select from ticks where i > x 1, i < x 2} each cuts;
 }

 /{select from (select by Group,Symbol from ticks where Group < 10, Symbol in `IBM`AOS`ATI) where i in x} each (9 3# til 27)
