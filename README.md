![Huh?](https://i.ibb.co/R06cZQ8/34174253.png)

---

A minimal interpreted esoteric language implemented in the WebAssembly text format.

In *huh* programs are specified by arrays of integers. All data, input and output, of a program is also an array of integers. Therefore, the language is naturally homoiconic. Moreover data and source code occupy the same space in memory such that every program is fundamentally self-modifying.

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
