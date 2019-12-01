(module

  (import "" "print" (func $print (param i32)))

  (memory (export "mem") 20) ;; 20*64K

  (func $binop
    (param $opCode i32)
    (param $arg1Address i32)
    (param $arg2Address i32)
    (param $returnAddress i32)

    (if (i32.eq (local.get $opCode) (i32.const 0)) ;; add
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.add
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 1)) ;; subtract
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.sub
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 2)) ;; multiply
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.mul
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 3)) ;; division (signed)
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.div_s
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 4)) ;; division (unsigned)
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.div_u
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 5)) ;; remainder (signed)
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.rem_s
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 6)) ;; remainder (unsigned)
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.rem_u
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 7)) ;; bitwise and
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.and
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 8)) ;; bitwise or
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.or
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 9)) ;; bitwise exclusive-or
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.xor
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 10)) ;; shift left
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.shl
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 11)) ;; shift right (signed)
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.shr_s
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 12)) ;; shift right (unsigned)
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.shr_u
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 13)) ;; rotate left
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.rotl
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 14)) ;; rotate right
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.rotr
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 15)) ;; equality
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.eq
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 16)) ;; inequality
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.ne
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 17)) ;; less than (signed)
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.lt_s
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 18)) ;; less than (unsigned)
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.lt_u
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 19)) ;; less than or equal to (signed)
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.le_s
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 20)) ;; less than or equal to (unsigned)
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.le_u
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 21)) ;; greater than (signed)
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.gt_s
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 22)) ;; greater than (unsigned)
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.gt_u
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 23)) ;; greater than or equal to (signed)
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.ge_s
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    (else (if (i32.eq (local.get $opCode) (i32.const 24)) ;; greater than or equal to (unsigned)
      (then
        (i32.store8
          (local.get $returnAddress)
          (i32.ge_u
            (i32.load8_u (local.get $arg1Address))
            (i32.load8_u (local.get $arg2Address))
          )
        )
      )
    )))))))))))))))))))))))))))))))))))))))))))))))))
  ) ;; end binop

  (func (export "run")

    ;; binop test: 6 + 4
    (i32.store8 (i32.const 0) (i32.const 6))
    (i32.store8 (i32.const 1) (i32.const 4))
    (call $binop (i32.const 0) (i32.const 0) (i32.const 1) (i32.const 2))
    (call $print (i32.load8_u (i32.const 2))) ;; expect 10

  ) ;; end run

)
