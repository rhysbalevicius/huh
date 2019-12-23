const repl = require('repl');
const fs = require('fs');
const readline = require('readline');
const buf = fs.readFileSync(__dirname + '/huh.wasm');
const mod = new WebAssembly.Module(new Uint8Array(buf));
const fns = { '' : { print : (i32) => console.log(i32) } }
const instance = new WebAssembly.Instance(mod, fns);
const instanceData = new Uint32Array(instance.exports.mem.buffer);

const exec = entry => {
  instance.exports.exec(entry);
};

const setupAndExec = (entry, source) => {
  instanceData.set(source, entry);
  exec(entry);
};

const readAndExec = (fname) => {
  let program = [];
  const lineReader = readline.createInterface({
    input: fs.createReadStream(fname)
  });

  lineReader.on('line', nextLine => {
    const line = nextLine.split(' ');
    for (let i of line) {
      if (i[0] === '#' || i[0] === ';' || i[0] === '/') break;
      else {
        let n = Math.abs(parseInt(i));
        if (n >= 0) program.push(n);
      }
    }
  });

  lineReader.on('close', () => {
    setupAndExec(0, program);
    const r = repl.start('> ');
    defineReplProp(r, 'data', instanceData, true);
    defineReplProp(r, 'exec', exec);
  });
};

const defineReplProp = (repl, name, value, enumerable=false, configurable=false) => {
  Object.defineProperty(repl.context, name, {
    configurable: configurable,
    enumerable: enumerable,
    value: value
  });
};

const fname = process.argv[2];
if (fname) {
  fs.stat(fname, err => {
    if (err === null) {
      console.log("Huh: Found "+fname);
      readAndExec(fname);
    } else if (err.code === 'ENOENT') {
      console.error(`File ${fname} does not exist`);
    } else {
      console.error('An unknown error has occurred');
    }
  });

} else if (require.main === module) {
  // called from command line
  console.error('Huh: No file provided');
  const r = repl.start('> ');
  defineReplProp(r, 'data', instanceData, true);
  defineReplProp(r, 'exec', exec);

} else {
  // called via require
  module.exports = {
    init: () => new WebAssembly.Instance(mod, fns).exports
  };
}
