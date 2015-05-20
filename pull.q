\l stocks
\t 1000
query:"curl -u Mzy@openf.in:Opnfn2015 http://batsrealtime.xignite.com/xBATSRealTime.csv/GetRealQuotesByIdentifiers\\?IdentifierType\\=Symbol\\&Identifiers\\=",1 _ raze {",",x} each string asc 1000 # exec TICKER from stocks;
grp:0;
result:system query;
headers:`Group,`$"," vs result 0;
data:{{(x 0) $ (x 1)} each flip (("SSSFSSDSFFFDFFFFFIFFFIIS"); ("," vs x))} each (1 _ result);
ticks:flip (headers!(enlist ((count data)# grp+:1)), flip data);
.z.ts:{
	result:system query;
	data:{{(x 0) $ (x 1)} each flip (("SSSFSSDSFFFDFFFFFIFFFIIS"); ("," vs x))} each (1 _ result);
	data:flip ((enlist ((count data)# grp+:1)), flip data);
	ticks,:data;
	-1 string count ticks;
 }