\l stocks
query:"curl -u Mazy@openf.in:Openfin2015 http://batsrealtime.xignite.com/xBATSRealTime.csv/GetRealQuotesByIdentifiers\\?IdentifierType\\=Symbol\\&Identifiers\\=",1 _ raze {",",x} each string asc 1000 # exec TICKER from stocks;
result:system query;
headers:`$"," vs result 0;
data:{{(x 0) $ (x 1)} each flip (("SSSFSSDSFFFDFFFFFIFFFIIS"); ("," vs x))} each (1 _ result);
ticks:flip (headers!flip data);

.z.ts:{
	result:system query;
	data:{{(x 0) $ (x 1)} each flip (("SSSFSSDSFFFDFFFFFIFFFIIS"); ("," vs x))} each (1 _ result);
	ticks,:data
 }