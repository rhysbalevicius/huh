![Huh?](https://i.ibb.co/R06cZQ8/34174253.png)

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

### How it works:

The interpreter first loads into memory an array of integers which specifies a program. Instructions are then read and executed sequentially beginning from an index, i.e. the entry point (zero by default).

There are five different types of instructions with each being of the form `a0 ... ak`.

**Halt**

Execution halts once the instruction `0` is read.


**Binary operations**

These are instructions of the form `1 w x y z` where `w` specifies the address to overwrite with the return value of the operation, `y` and `z` are the respective addresses of the left and right hand arguments, and `x` is an opcode in the range `[0, 24]` specifying the operation to be used. Note that if `x` is outside this range a value of `0` is returned by default.

For reference here are the corresponding opcodes:
```
0 -> i32.add -- addition
1 -> i32.sub -- subtraction
2 -> i32.mul -- multiplication
3 -> i32.div_s -- division (signed)
4 -> i32.div_u -- division (unsigned)
5 -> i32.rem_s -- remainder (signed)
6 -> i32.rem_u -- remainder (unsigned)
7 -> i32.and -- bitwise and
8 -> i32.or -- bitwise or
9 -> i32.xor -- bitwise xor
10 -> i32.shl -- shift left
11 -> i32.shr_s -- shift right (signed)
12 -> i32.shr_u -- shift right (unsigned)
13 -> i32.rotl -- rotate left
14 -> i32.rotr -- rotate right
15 -> i32.eq -- equality
16 -> i32.ne -- inequality
17 -> i32.lt_s -- less than (signed)
18 -> i32.lt_u -- less than (unsigned)
19 -> i32.le_s -- less than or equal to (signed)
20 -> i32.le_u -- less than or equal to (unsigned)
21 -> i32.ge_s -- greater than (signed)
22 -> i32.ge_u -- greater than (unsigned)
23 -> i32.ge_s -- greater than or equal to (signed)
24 -> i32.ge_u -- greater than or equal to (unsigned)
```
For more information regarding these operations see [here](https://github.com/sunfishcode/wasm-reference-manual/blob/master/WebAssembly.md#integer-arithmetic-instructions).
