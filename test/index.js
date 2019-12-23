const expect = require('chai').expect;
const huh = require('../src/huh.js');

const setupAndExec = (source) => {
  const instance = huh.init();
  const instanceData = new Uint32Array(instance.mem.buffer);
  instanceData.set(source, 0);
  instance.exec();
  return instanceData;
}

describe('Huh instructions', function(){

  it('Binops: Compute (5*7)-2', function() {
    const instanceData = setupAndExec(
      [ 1, 14, 2, 11, 12, 1, 14, 1, 14, 13, 0, 5, 7, 2 ]
    );
    expect(instanceData[14]).to.equal(33);
  });

  it('Control flow: 5<7 ? 2+2 : 5*2', function() {
    const instanceData = setupAndExec(
      [ 2, 18, 18, 19, 8, 1, 21, 0, 20, 20, 3, 17, 1, 21, 2, 18, 20, 0, 5, 7, 2 ]
    );
    expect(instanceData[21]).to.equal(4);
  });

  it('Control flow: 7<5 ? 2+2 : 5*2', function() {
    const instanceData = setupAndExec(
      [ 2, 18, 19, 18, 8, 1, 21, 0, 20, 20, 3, 17, 1, 21, 2, 18, 20, 0, 5, 7, 2 ]
    );
    expect(instanceData[21]).to.equal(10);
  });

  it('Looping: count to 255', function() {
    const instanceData = setupAndExec(
      [ 4, 2, 15, 1, 17, 0, 17, 16, 1, 15, 18, 17, 14, 0, 255, 0, 1 ]
    );
    expect(instanceData[17]).to.equal(255);
  });

  it('Compute 25th fibonacci number', function() {
    const instanceData = setupAndExec(
      [ 4, 5, 30, 1, 33, 0, 34, 35, 1, 35, 0, 34, 36, 1, 34, 0, 33, 36, 1, 32, 0, 32, 31, 1, 30, 18, 32, 29, 0, 25, 0, 1, 0, 0, 0, 1 ]
    );
    expect(instanceData[34]).to.equal(75025);
  });

  it('Compute 100th triangle number', function() {
    const instanceData = setupAndExec(
      [ 4, 3, 20, 1, 23, 0, 23, 22, 1, 22, 0, 22, 21, 1, 20, 20, 22, 19, 0, 100, 0, 1 ]
    );
    expect(instanceData[23]).to.equal(5050);
  });

  it('Quine: self replicating source code', function() {
    const quine = [ 4, 4, 37, 1, 38, 0, 33, 0, 1, 7, 0, 7, 34, 1, 4, 0, 4, 34, 1, 37, 18, 7, 35, 1, 42, 0, 36, 33, 1, 45, 0, 33, 33, 0, 1, 37, 38 ];
    const instanceData = setupAndExec(quine);
    expect(Array.from(instanceData.slice(38,75))).to.deep.equal(quine);
  });

});
