\p 54321
\e 1

timezoneOffset:-04:00:00;

ticks:-9!read1 `:ticks10;

minutesOnly:{(`date$x) + (`minute$x)};

asUTC:{r:(string neg[timezoneOffset]+x),"Z";r[(4;7)]:"-";r};

query:{[message]
	validFields: asc (key meta ticks)`c;
	map: message`data;
	startTime: map`startTime;
	startTime: $[startTime~"";"z"$0;"Z"$(-1 _ startTime)];

	endTime: map`endTime;
	endTime: $[endTime~"";0Nz;"Z"$(-1 _ endTime)];

	records: "i"$map`records;
	interval: map`interval;
	intervalUnit: map`intervalUnit;
	symbolList: `$map`symbolList;
	fieldList: (`$map`fieldList) inter validFields;
	result: $[endTime~0Nz;select from ticks where Symbol in symbolList, DT > timezoneOffset+startTime;select from ticks where Symbol in symbolList, DT > timezoneOffset+startTime, DT < timezoneOffset+endTime];
	result: `Date`Symbol xasc update Date: asUTC each "z"$ minutesOnly each DT from result;
	result: update Close:Last from result;
	$[not -7h~type records;records:5000;];
	result: neg[records & count result] # result;
	result: ?[result;();0b;(fieldList,`Date)!(fieldList,`Date)];
	message[`result]: flip result;
	json: .j.j message;
	neg[.z.w] json;
	-1 raze raze string (timezoneOffset+startTime;", ";timezoneOffset+endTime;", ";records;", ";count result);
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