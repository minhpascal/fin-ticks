// load this script into your q script for
// a simple interface to the hypergrid using the q behavior

$[.z.K<3.19999;0N! "You need version 3.2 or later for this, please download a more recent version of q";]
\p 5000

features:flip (
    (`sorting;   0b);
    (`columnReordering;   0b)
    );

features:features[0]!features[1];

window:{[tableName;start;num]
    ii: start + til num;
    ([]row:ii),'(value tableName)[ii]}

.z.ws:{
  LASTCLIENT:: .z.w;
  message: .j.c x;
  TABLENAME::(message`data)`table;
  @[`$message`cmd;message];
 }

fetchTableRowCount: {
 data:x`data;
 count (value data`table)}

fetchTableData: {
  data:x`data;
  json: .j.j (`data`rows`headers`features)!(value each window[(TABLENAME);`long$(data`start);`long$(data`num)];fetchTableRowCount x;(enlist (`row;"j")),(value each select c,t from meta (value TABLENAME));features);
  neg[LASTCLIENT] json; //negating a handle makes the sending of data async;
  LASTUPDATE:: x;
 }

pushUpdates: {
   $[`LASTUPDATE in value "\\v";fetchTableData[LASTUPDATE];]
 }

sf:parse "delete av from `av xasc update av:abs quantity from `myTable"
sortTable: {
    data:x`data;
    $[0~count data`sort;
        [];
        [sf[1;2;4;`av]:(`$data`sort);
         sf[1;2;1;0]:`$(TABLENAME);
         $[data`abs;
            $[11h~type ((value TABLENAME)`$data`sort);;sf[1;2;4]:(enlist`av)!enlist (abs;`$data`sort)];
            ()];
        sf[1;0]:$[data`asc;xasc;xdesc];
        eval sf]
   ];
   fetchTableData[x];
 }
