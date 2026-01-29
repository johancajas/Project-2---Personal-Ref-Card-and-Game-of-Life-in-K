/ Conway's Game of Life in ngn/k
/ Array-based implementation with wraparound edges

/ rotate: rotate list by k positions
rotate:{[k;l]l@((#l)!(-k)+!#l)}

/ rotate2d: rotate a 2d matrix - rows by j, columns by k
rotate2d:{[j;k;m](rotate[j]')rotate[k]'m}

/ neighborhoodCounts: count live neighbors for each cell
neighborhoodCounts:{[board]shifts:(-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1);+/{rotate2d[x 0;x 1;board]}'shifts}

/ nextGeneration: apply Game of Life rules
nextGeneration:{[board]counts:neighborhoodCounts[board];(counts=3)|board&counts=2}

/ simulateGameOfLife: run n generations
simulateGameOfLife:{[n;board]n nextGeneration/board}

/ makeGliderBoard: create board with a glider pattern
makeGliderBoard:{[rows;cols]b:(rows;cols)#0;b[1;2]:1;b[2;3]:1;b[3;1]:1;b[3;2]:1;b[3;3]:1;b}

/ showBoard: display board with . and * characters
showBoard:{[board]`0:'{"*."x}'board}

/ Test tracking
testsPassed:0
testsFailed:0

/ assertEqual: check if two values are equal
assertEqual:{[expected;actual;testName]result:expected~actual;$[result;[testsPassed::testsPassed+1;`0:"✓ ",testName];[testsFailed::testsFailed+1;`0:"✗ ",testName]];result}

/ Run all tests
runTests:{[]testsPassed::0;testsFailed::0;`0:"Running Game of Life Tests...";`0:"";assertEqual[3 4 5 1 2;rotate[-2;1 2 3 4 5];"rotate: shift last 2 to front"];assertEqual[4 5 1 2 3;rotate[2;1 2 3 4 5];"rotate: shift by positive 2"];assertEqual[1 2 3;rotate[0;1 2 3];"rotate: no rotation"];assertEqual[3 1 2;rotate[-1;1 2 3];"rotate: shift last 1 to front"];m:(1 2 3;4 5 6;7 8 9);expected:(6 4 5;9 7 8;3 1 2);assertEqual[expected;rotate2d[-1;-1;m];"rotate2d: rotate rows and cols by -1"];assertEqual[m;rotate2d[0;0;m];"rotate2d: no rotation"];board3x3:(0 0 0;0 1 0;0 0 0);counts3x3:neighborhoodCounts[board3x3];assertEqual[1;counts3x3[0;0];"neighborhoodCounts: corner counts center"];assertEqual[1;counts3x3[1;1];"neighborhoodCounts: center counts itself via wrap"];blinker:(0 0 0 0 0;0 0 1 0 0;0 0 1 0 0;0 0 1 0 0;0 0 0 0 0);counts:neighborhoodCounts[blinker];assertEqual[2;counts[2;2];"neighborhoodCounts: blinker center has 2 neighbors"];assertEqual[1;counts[1;2];"neighborhoodCounts: blinker end has 1 neighbor"];glider:makeGliderBoard[7;7];assertEqual[1;glider[1;2];"makeGliderBoard: glider position [1,2]"];assertEqual[1;glider[2;3];"makeGliderBoard: glider position [2,3]"];assertEqual[1;glider[3;1];"makeGliderBoard: glider position [3,1]"];assertEqual[5;+/+/glider;"makeGliderBoard: glider has exactly 5 live cells"];blinkerH:(0 0 0 0 0;0 0 1 0 0;0 0 1 0 0;0 0 1 0 0;0 0 0 0 0);blinkerV:(0 0 0 0 0;0 0 0 0 0;0 1 1 1 0;0 0 0 0 0;0 0 0 0 0);assertEqual[blinkerV;nextGeneration[blinkerH];"nextGeneration: blinker horizontal to vertical"];assertEqual[blinkerH;nextGeneration[blinkerV];"nextGeneration: blinker vertical to horizontal"];assertEqual[blinkerH;simulateGameOfLife[2;blinkerH];"simulateGameOfLife: blinker period 2"];assertEqual[blinkerH;simulateGameOfLife[100;blinkerH];"simulateGameOfLife: blinker stable over 100 even gens"];block:(0 0 0 0;0 1 1 0;0 1 1 0;0 0 0 0);assertEqual[block;simulateGameOfLife[1;block];"simulateGameOfLife: block stable after 1 gen"];assertEqual[block;simulateGameOfLife[10;block];"simulateGameOfLife: block stable after 10 gens"];`0:"";`0:"==========================================";`0:"TEST SUMMARY";`0:"==========================================";`0:"Passed: ",$testsPassed;`0:"Failed: ",$testsFailed;`0:"Total:  ",$(testsPassed+testsFailed);$[testsFailed=0;`0:"✓ ALL TESTS PASSED!";`0:"✗ SOME TESTS FAILED"];`0:"==========================================" }

/ Main demonstration
demo:{[]`0:"==========================================";`0:"Conway's Game of Life - Glider on 7x7 Board";`0:"==========================================";`0:"";board:makeGliderBoard[7;7];`0:"Initial Board (Generation 0):";showBoard[board];`0:"";finalBoard:simulateGameOfLife[100;board];`0:"Final Board (Generation 100):";showBoard[finalBoard];`0:"";`0:"(Glider has moved due to wraparound on edges)";`0:"" }

/ Run demonstration
demo[]

/ Run all tests
runTests[]
