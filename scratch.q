bars:{[message]

	map: message`data;
	
	portfolio:`$first map`symbolList;
	isPortfolio:portfolio in key portfolios;

	$[isPortfolio;map[`symbolList]:portfolios[portfolio];];

	validFields: asc (key meta ticks)`c;
	startTime: map`startTime;
	startTime: timezoneOffset + $[startTime~"";"z"$0;"Z"$(-1 _ startTime)];

	endTime: map`endTime;
	endTime: timezoneOffset+$[endTime~"";0Nz;"Z"$(-1 _ endTime)];

	records: map`records;
	records:$[10h~type map`records;0Nf;records];
	interval: map`interval;
	intervalUnit: map`intervalUnit;
	symbolList: $[isPortfolio;`$string (map`symbolList);`$map`symbolList];
	fieldList: (`$map`fieldList) inter validFields;
	result: $[endTime~0Nz;select from ticks where Symbol in symbolList, DT > startTime;select from ticks where Symbol in symbolList, DT > startTime, DT < endTime];
	result: `Date`Symbol xasc update Date: asUTC each "z"$ minutesOnly each DT from result;
	result: $[isPortfolio;
		() xkey value (?;result;();(enlist `Date)!(enlist `Date);(fieldList,`Last)!flip ((1+count fieldList) # avg;(fieldList,`Last)));
		?[result;();0b;(fieldList,`Date,`Last)!(fieldList,`Date,`Last)]];
	result: ()xkey select by Date from result;
	records: $[records~0Nf;5000;records];
	result: ("i"$neg[records & count result]) # result;
	result: update Close:Last from result;
	Q;

	message[`result]: flip result;
	json: .j.j message;
	neg[.z.w] json;
	-1 raze raze string (startTime;", ";endTime;", ";records;", ";count result;", ";map`querystring);
 }