![Huh?](https://i.ibb.co/R06cZQ8/34174253.png)

[![master branch tests](https://img.shields.io/travis/r-ba/huh/master.svg?label=master%20branch)](https://travis-ci.com/r-ba/huh)
[![GitHub license](https://img.shields.io/badge/License-MIT-blue.svg)](https://raw.githubusercontent.com/r-ba/huh/master/LICENSE)
---

A minimal interpreted esoteric language implemented in the WebAssembly text format.

In *huh* programs are specified by arrays of integers. All data, input and output, of a program is also an array of integers. Therefore the language is naturally homoiconic. Moreover data and source code occupy the same space in memory such that every program is fundamentally self-modifying.

---

### How about a [quine](https://en.wikipedia.org/wiki/Quine_%28computing%29)

```
4 4 37
1 38 0 33 0
1 7 0 7 34
1 4 0 4 34
1 37 18 7 35
1 42 0 36 33
1 45 0 33 33
0
1 37 38
```

### Huh?
Exactly.

---

### Usage

A simple interpreter, which piggybacks off of the node.js repl, is provided by `src/huh.js`. Source code can be passed to the interpreter either as a file, or written manually from within the context of the repl. Note that files passed into the interpreter are executed before providing access to the repl.


Inside the repl the interpreter's memory is exposed through a Uint32Array named `data`. Programs may be executed via a function named `exec()` that takes a single integer `entry` as it's argument which specifes where to begin reading in instructions from memory.

For example:
```
$ node src/huh.js examples/fibonacci.huh
Huh: Found examples/fibonacci.huh
> data[34]
75025
> data.set([1,50,1,34,35],100)
> exec(100)
> data[50]
28657
```

It's also possible to include instances of a *huh* interpreter from within other JavaScript files:
```js
const huh = require('./src/huh.js');
const instance = huh.init();
const data = new Uint32Array(instance.mem.buffer);
data.set([1,0,0,0,0], 0);
instance.exec();
console.log(data[0]); // -> 2
```

---

### How it works

The interpreter first loads into memory an array of integers which specifies a program. Instructions are then read and executed sequentially beginning from an index, i.e. the entry point (zero by default).

A "program" is defined as a contiguous sequence of subarrays. Each subarray defines an "instruction". There are five different types of instructions:

##### *0. Halt*

Execution halts once the instruction `0` is read.


##### *1. Binary operations*

These are instructions of the form `1 w x y z` where `w` specifies the address to overwrite with the return value of the operation, `y` and `z` are the respective addresses of the left and right hand arguments, and `x` is an opcode in the range `[0, 24]` specifying the operation to be used. Note that if `x` is outside this range a value of `0` is returned by default.

A reference of the corresponding opcodes can be found at the bottom of this section.

##### *2. Control flow*

These are instructions of the form `2 w x y z ... 3 v ...` where `w` specifies the opcode used to evaluate the conditional expression, `x` and `y` are the respective left and right hand side arguments passed to `w`. To be properly defined `z` must be the address of the else block, and `v` is the address of the first instruction outside of the else block.

##### *3. Jump statements*

These are instructions of the form `3 x` where `x` specifies which instruction to continue executing from.

##### *4. Loops*

These are instructions of the form `4 x y ...` where `x` specifies the number of instructions in the body of the loop, and `y` specifies the address in memory which is checked after each iteration. Execution of the loop continues as long as `y` points to non-zero value.

##### Comments

Within a file passed to the interpreter, any non-numeric characters are ignored and may be used for the sake of commenting. Furthermore, any appearance of `#`, `;`, or `/` causes the interpreter to skip to the next line.

##### Opcodes:
```
0 -> addition
1 -> subtraction
2 -> multiplication
3 -> division (signed)
4 -> division (unsigned)
5 -> remainder (signed)
6 -> remainder (unsigned)
7 -> bitwise and
8 -> bitwise or
9 -> bitwise xor
10 -> shift left
11 -> shift right (signed)
12 -> shift right (unsigned)
13 -> rotate left
14 -> rotate right
15 -> equality
16 -> inequality
17 -> less than (signed)
18 -> less than (unsigned)
19 -> less than or equal to (signed)
20 -> less than or equal to (unsigned)
21 -> greater than (signed)
22 -> greater than (unsigned)
23 -> greater than or equal to (signed)
24 -> greater than or equal to (unsigned)
```
