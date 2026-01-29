/ Johan Cajas
/ (put today’s date)
/ Project 2: Ref Card + Game of Life in ngn/k

print:{`0:x;}
printLines:{[lines]print "\n"/lines;}
testsPassed:0
testsFailed:0
recordPass:{."testsPassed:testsPassed+1"}
recordFail:{."testsFailed:testsFailed+1"}
currentTest:{`k@."testsPassed+testsFailed"}
summarizeTestResults:{printLines[("\nTest Results:";"\tPassed: ",`k@."testsPassed";"\tFailed: ",`k@."testsFailed";"")]}

is:{[expected;observed]
  $[expected~observed;
    recordPass[];
    recordFail[];
    printLines(("";"\tAssertion ";currentTest[];" failed:";"\tExpected: ",`k@expected;"\tBut was:  ",`k@observed;""))]
}

/ -------- helpers --------
blankBoard:{[r;c] r#(c#0)}
setCells:{[b;coords] b {@[x;y;:;1]}/ coords}

/ rotate: move last k items to the front
rotate:{[k;x]
  n:#x;
  k:n!(k+n);          / normalize (works for negatives too)
  (n-k)_x,(n-k)#x
}

/ rotate2d: rotate each row by k, then rotate rows by j
rotate2d:{[j;k;m]
  rotate[j; {rotate[k;x]}'m]
}

/ neighborhoodCounts: count live neighbors with wrap-around
neighborhoodCounts:{[b]
  shifts:(-1 -1;-1 0;-1 1;0 -1;0 0;0 1;1 -1;1 0;1 1);
  all:+/{rotate2d[x@0;x@1;b]}'shifts;   / sum 9 shifted boards (includes self)
  all-b                                 / remove self to get only neighbors
}

/ makeGliderBoard: create r x c with one glider at top-left
makeGliderBoard:{[r;c]
  b:blankBoard[r;c];
  coords:(0 1;1 2;2 0;2 1;2 2);
  setCells[b;coords]
}

/ one generation step
step:{[b]
  n:neighborhoodCounts b;
  alive:1=b;
  (alive & ((2=n)|(3=n))) | ((~alive) & (3=n))
}

/ simulateGameOfLife: run gens steps starting from board
simulateGameOfLife:{[gens;b] gens step/ b}

/ pretty-print board (0 -> . , 1 -> #)
rowToStr:{""/(".";"#")@x}
boardToLines:{rowToStr' x}
printBoard:{[b] printLines[boardToLines b]}

/ ----------- TESTS -----------

/ rotate tests
is[4 1 2 3][rotate[1;1 2 3 4]]
is[3 4 1 2][rotate[2;1 2 3 4]]
is[1 2 3 4][rotate[0;1 2 3 4]]
is[2 3 4 1][rotate[-1;1 2 3 4]]

/ rotate2d tests
m:(1 2 3;4 5 6;7 8 9);
is[(9 7 8;3 1 2;6 4 5)][rotate2d[1;1;m]]
is[m][rotate2d[0;0;m]]

/ neighborhoodCounts tests
b1:(0 0 0;0 1 0;0 0 0);
is[(1 1 1;1 0 1;1 1 1)][neighborhoodCounts b1]
b0:(0 0 0;0 0 0;0 0 0);
is[b0][neighborhoodCounts b0]

/ makeGliderBoard test (5x5)
g5:makeGliderBoard[5;5];
g5Expected:(0 1 0 0 0;
            0 0 1 0 0;
            1 1 1 0 0;
            0 0 0 0 0;
            0 0 0 0 0);
is[g5Expected][g5]

/ simulateGameOfLife test: glider moves down-right by 1 every 4 gens
g7:makeGliderBoard[7;7];
g7After4:simulateGameOfLife[4;g7];
g7After4Expected:blankBoard[7;7];
g7After4Expected:setCells[g7After4Expected;(1 2;2 3;3 1;3 2;3 3)];
is[g7After4Expected][g7After4]

/ ----------- RUN DEMO (for screenshot) -----------
printLines[("Initial 7x7 glider board:";"")]
bStart:makeGliderBoard[7;7];
printBoard bStart

bFinal:simulateGameOfLife[100;bStart];
printLines[("" ;"Final board after 100 generations:";"")]
printBoard bFinal

summarizeTestResults[]
