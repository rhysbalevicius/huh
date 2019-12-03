(module

  (import "" "print" (func $print (param i32)))
  (memory (export "mem") 20) ;; 20*64K

  ;; A binary operation
  ;;
  (func $binop
    (param $opCodeAddress i32)
    (param $arg0Address i32)
    (param $arg1Address i32)
    (result i32)

    (local $opc i32)  ;; opcode specifying which binop to use
    (local $lhs i32)  ;; the lefthand param to pass to the binop
    (local $rhs i32)  ;; the righthand param to pass to the binop

    ;; load the opcode pointed to by $opCodeAddress
    (set_local $opc (i32.load8_u (local.get $opCodeAddress)))

    ;; load the arg addresses pointed to by $argAddress,
    ;; and then load their corresponding values
    (set_local $lhs (i32.load8_u (i32.load8_u (local.get $arg0Address))))
    (set_local $rhs (i32.load8_u (i32.load8_u (local.get $arg1Address))))

    ;; evaluate the binop, returning the result
    (if (i32.eq (local.get $opc) (i32.const 0))         ;; addition
      (then
        (return (i32.add (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 1))   ;; subtraction
      (then
        (return (i32.sub (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 2))   ;; multiplication
      (then
        (return (i32.mul (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 3))   ;; division (signed)
      (then
        (return (i32.div_s (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 4))   ;; division (unsigned)
      (then
        (return (i32.div_u (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 5))   ;; remainder (signed)
      (then
        (return (i32.rem_s (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 6))   ;; remainder (unsigned)
      (then
        (return (i32.rem_u (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 7))   ;; bitwise and
      (then
        (return (i32.and (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 8))   ;; bitwise or
      (then
        (return (i32.or (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 9))   ;; bitwise exclusive-or
      (then
        (return (i32.xor (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 10))  ;; shift left
      (then
        (return (i32.shl (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 11))  ;; shift right (signed)
      (then
        (return (i32.shr_s (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 12))  ;; shift right (unsigned)
      (then
        (return (i32.shr_u (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 13))  ;; rotate left
      (then
        (return (i32.rotl (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 14))  ;; rotate right
      (then
        (return (i32.rotr (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 15))  ;; equality
      (then
        (return (i32.eq (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 16))  ;; inequality
      (then
        (return (i32.ne (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 17))  ;; less than (signed)
      (then
        (return (i32.lt_s (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 18))  ;; less than (unsigned)
      (then
        (return (i32.lt_u (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 19))  ;; less than or equal to (signed)
      (then
        (return (i32.le_s (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 20))  ;; less than or equal to (unsigned)
      (then
        (return (i32.le_u (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 21))  ;; greater than (signed)
      (then
        (return (i32.gt_s (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 22))  ;; greater than (unsigned)
      (then
        (return (i32.gt_u (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 23))  ;; greater than or equal to (signed)
      (then
        (return (i32.ge_s (local.get $lhs) (local.get $rhs)))
      )
    (else (if (i32.eq (local.get $opc) (i32.const 24))  ;; greater than or equal to (unsigned)
      (then (return (i32.ge_u (local.get $lhs) (local.get $rhs)))
      )
    )))))))))))))))))))))))))))))))))))))))))))))))))

    (return (i32.const 0)) ;; default binop return value

  ) ;; end $binop

) ;; end module
