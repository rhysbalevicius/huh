const fs = require('fs');
const readline = require('readline');
const buf = fs.readFileSync('./huh.wasm');
const mod = new WebAssembly.Module(new Uint8Array(buf));
const fns = { "" : { print : (i32) => console.log(i32) } }
const instance = new WebAssembly.Instance(mod, fns);
const instanceData = new Uint32Array(instance.exports.mem.buffer);

const setupAndExec = (entry, source) => {
  let i = entry;
  for (let j in source) instance.exports.setup(i++, source[j]);
  instance.exports.exec(entry);
};

const readAndExec = (fname) => {
  let program = [];
  const lineReader = readline.createInterface({
    input: fs.createReadStream(fname)
  });

  lineReader.on('line', nextLine => {
    const line = nextLine.split(" ");
    for (let i of line) {
      if (i[0] === "#" || i[0] === ";" || i[0] === "/") break;
      else {
        let n = Math.abs(parseInt(i));
        if (n >= 0) program.push(n);
      }
    }
  });

  lineReader.on('close', () => {
    setupAndExec(0, program);
    const i = Math.abs(parseInt(process.argv[3]));
    if (i >= 0) console.log(instanceData[i]);
  });
};

const fname = process.argv[2];
if (fname) {
  fs.stat(fname, err => {
    if (err === null) {
      readAndExec(fname);
    } else if (err.code === 'ENOENT') {
      console.error(`File ${fname} does not exist`);
    } else {
      console.error(`An unknown error has occurred`);
    }
  });
} else {
  console.error("No file provided")
}
