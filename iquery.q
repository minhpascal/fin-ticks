\p 54321
\e 1

//select Close:avg Close by p,minute from update minute:(DT.month+DT.minute), p:(first each string Symbol) in "ABCDEFGHIJKL" from ticks

portfolios:flip ((`$"P@0";`AA`BA`GM`KO`LUV);
			(`$"P@1";`S`UTX`X`Y`YUM));

portfolios:portfolios[0]!portfolios[1];

timezoneOffset:-04:00:00;

ticks:-9!read1 `:ticks10;
ticks,:-9!read1 `:ticks11;
ticks,:-9!read1 `:ticks11;

minutesOnly:{(`date$x) + (`minute$x)};

asUTC:{r:(string neg[timezoneOffset]+x),"Z";r[(4;7)]:"-";r};

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

	message[`result]: flip result;
	json: .j.j message;
	neg[.z.w] json;
	-1 raze raze string (startTime;", ";endTime;", ";records;", ";count result;", ";map`querystring);
 }

components:{[message]
	map: message`data;
	security: `$map`security;
	list: portfolios[security];
	message[`result]: list;
	json: .j.j message;
	neg[.z.w] json;
 }

fields:{[message]
	message[`result]: asc (key meta ticks)`c;
	json: .j.j message;
	neg[.z.w] json;
 }

symbols:{[message]
	message[`result]: asc exec distinct Symbol from ticks;
	json: .j.j message;
	neg[.z.w] json;
 }

.z.ws:{
  message: .j.c x;
  -1 message`cmd;
  @[`$message`cmd;message];
 }

/
 this.ws.onopen = function() {
   console.log('connected');
    self.ws.send(JSON.stringify({
        cmd: 'query',
        data: {
            	startTime: '2000-01-01T00:00:00Z',
				endTime: '2015-05-22T00:00:00Z',
				records: 200,
				interval: 1,
				intervalUnit: 'm',
				symbolList: ['IBM','BAX','BAM'],
				fieldList: [],
        }
    }));
};

// returns 1000 records up until 5/21/2015, all fields, with one record each day, for IBM