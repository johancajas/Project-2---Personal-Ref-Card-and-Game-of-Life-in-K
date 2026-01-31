/ Conway's Game of Life in K

/ Rotate array by k positions
rot:{[k;x] $[k<0;rot[k+#x;x];k=0;x;(k_x),k#x]}

/ Rotate 2D matrix
rot2d:{[r;c;m] rot[c]'rot[r]'m}

/ Count neighbors for each cell (with wraparound)
nbrs:{[b]
  +/(rot2d[(-1);(-1);b];rot2d[(-1);0;b];rot2d[(-1);1;b];rot2d[0;(-1);b];rot2d[0;1;b];rot2d[1;(-1);b];rot2d[1;0;b];rot2d[1;1;b])}

/ Next generation (Game of Life rules)
next:{[b] n:nbrs[b]; (n=3)|b&n=2}

/ Run n generations
sim:{[n;b] n next/b}

/ Create glider pattern
glider:{[r;c] b:(r;c)#0; b[1;2]:1;b[2;3]:1;b[3;1]:1;b[3;2]:1;b[3;3]:1; b}

/ Display board
show:{[b] `0:'{"*."x}'b}

/ Test counters
pass:0
fail:0

/ Test function
test:{[exp;act;name] result:exp~act; $[result;[pass::pass+1;`0:"PASS: ",name];[fail::fail+1;`0:"FAIL: ",name]]; result}

/ Run all tests
tests:{[]
  pass::0;
  fail::0;
  `0:"Running Tests...";
  `0:"";
  test[3 4 5 1 2;rot[2;1 2 3 4 5];"rot: shift by 2"];
  test[1 2 3;rot[0;1 2 3];"rot: no rotation"];
  m:(1 2 3;4 5 6;7 8 9);
  test[m;rot2d[0;0;m];"rot2d: no rotation"];
  b3:(0 0 0;0 1 0;0 0 0);
  n3:nbrs[b3];
  test[0;n3[0;0];"nbrs: corner with wraparound"];
  bh:(0 0 0 0 0;0 0 1 0 0;0 0 1 0 0;0 0 1 0 0;0 0 0 0 0);
  bv:(0 0 0 0 0;0 0 0 0 0;0 1 1 1 0;0 0 0 0 0;0 0 0 0 0);
  test[bv;next[bh];"next: blinker h to v"];
  test[bh;next[bv];"next: blinker v to h"];
  test[bh;sim[2;bh];"sim: blinker period 2"];
  blk:(0 0 0 0;0 1 1 0;0 1 1 0;0 0 0 0);
  test[blk;next[blk];"next: block stable"];
  test[blk;sim[10;blk];"sim: block stable 10 gens"];
  g:glider[7;7];
  test[5;+/+/g;"glider: 5 live cells"];
  test[1;g[1;2];"glider: cell at [1,2]"];
  `0:"";
  `0:"=========================";
  `0:"PASSED: ",$pass;
  `0:"FAILED: ",$fail;
  `0:"TOTAL:  ",$(pass+fail);
  `0:"========================="}

/ Demo
demo:{[]
  `0:"";
  `0:"Game of Life Demo";
  `0:"=================";
  `0:"";
  `0:"Generation 0:";
  b:glider[10;10];
  show[b];
  `0:"";
  `0:"Generation 4:";
  show[sim[4;b]];
  `0:""}

tests[]
demo[]
