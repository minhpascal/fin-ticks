\p 54321
\e 1
ticks:-9!read1 `:ticks10;

minutesOnly:{(`date$x) + (`minute$x)};

query:{[message]
	map: message`data;
	startTime: map`startTime;
	endTime: map`endTime;
	records: map`records;
	interval: map`interval;
	intervalUnit: map`intervalUnit;
	symbolList: ",",map`symbolList;
	fieldList: map`fieldList;

	startTime: "Z"$(-1 _ startTime);
	endTime: "Z"$(-1 _ endTime);
	symbolList: `$ $[count where symbolList=",";1 _' ((where symbolList=",") _ symbolList);1 _ symbolList];
	result: select from ticks where Symbol in symbolList, DT > startTime, DT < endTime;
	result: `DT`Symbol xasc update DT: "z"$ minutesOnly each DT from result;
	result: ("i"$(records & count result)) # result;
	message[`result]: result;
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
				symbolList: 'IBM,BAX,BAM',
				fieldList: ''
        }
    }));
};

// returns 1000 records up until 5/21/2015, all fields, with one record each day, for IBM