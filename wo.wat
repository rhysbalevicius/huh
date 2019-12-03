(module

  (import "" "print" (func $print (param i32)))
  (memory (export "mem") 20) ;; 20*64K
  
  ;; Evaluate the next instruction
  ;;
  (func $next
    (param $ip i32)
    (result i32)

    ;; execution halts once ip points to 0 (at the end of an instruction "chunk")
    (if (i32.eq (i32.load8_u (local.get $ip)) (i32.const 1))
      ;; binop
      (then
        ;; evaulate a binary operation and store the result in memory
        (i32.store8
          (i32.load8_u (tee_local $ip (i32.add (local.get $ip) (i32.const 1)))) ;; -> return address
          (call $binop
            (tee_local $ip (i32.add (local.get $ip) (i32.const 1))) ;; -> opcode address
            (tee_local $ip (i32.add (local.get $ip) (i32.const 1))) ;; -> lhs arg address
            (tee_local $ip (i32.add (local.get $ip) (i32.const 1))) ;; -> rhs address
          )
        )
        ;; increment ip to point to the next instruction in memory
        (set_local $ip (i32.add (local.get $ip) (i32.const 1)))
      )
    ;; conditional -- skip to memory[ip] if condition evaluates to false
    (else (if (i32.eq (i32.load8_u (local.get $ip)) (i32.const 2))
      (then
        ;; compute the ip offset, if => 1, else => memory[ip]
        (set_local $ip
          (call $switch
            (tee_local $ip (i32.add (local.get $ip) (i32.const 1))) ;; -> opcode address
            (tee_local $ip (i32.add (local.get $ip) (i32.const 1))) ;; -> lhs arg address
            (tee_local $ip (i32.add (local.get $ip) (i32.const 1))) ;; -> rhs address
            (tee_local $ip (i32.add (local.get $ip) (i32.const 1))) ;; -> "else" branch offset
          )
        )
      )
    ;; jump -- go to instruction memory[ip]
    (else (if (i32.eq (i32.load8_u (local.get $ip)) (i32.const 3))
      (then
        (set_local $ip
          (i32.load8_u (i32.add (local.get $ip) (i32.const 1)))
        )
      )
    ;; loop
    (else (if (i32.eq (i32.load8_u (local.get $ip)) (i32.const 4))
      (then
        (set_local $ip
          (call $loop
            (tee_local $ip (i32.add (local.get $ip) (i32.const 1))) ;; -> length
            (tee_local $ip (i32.add (local.get $ip) (i32.const 1))) ;; -> halt address
          )
        )
      )
    )))))))

    ;; return $ip to continue program execution
    (return (local.get $ip))

  ) ;; end $next


  ;; A "while true" statement
  ;;
  (func $loop
    (param $lengthAddress i32)
    (param $ip i32)
    (result i32)

    (local $inst i32)    ;; the current instruction being executed
    (local $length i32)  ;; the number of instructions to be executed by the loop
    (local $top i32)    ;; -> beginning of loop

    ;; retrieve the number of instructions to execute
    (set_local $length (i32.load8_u (local.get $lengthAddress)))

    ;; store a copy of $ip, since we'll be modifying it
    ;; points to the value which determines whether or not to halt
    (set_local $top (local.get $ip))

    ;; set $ip to point to the first instruction
    (set_local $ip (i32.add (local.get $ip) (i32.const 1)))

    (loop

      ;; evaluate next instruction and increment ip to the next instruction
      (set_local $ip (call $next (local.get $ip)))

      ;; increment the instruction count
      (set_local $inst (i32.add (local.get $inst) (i32.const 1)))

      (br_if 0
        (i32.ne (local.get $inst) (local.get $length))
      )
    )

    ;; once a cycle of the loop has completed, check the value corresponding
    ;; to the halt address -- if it's not 0, point ip to the top of the loop
    (if (i32.load8_u (i32.load8_u (local.get $top)))
      (then
        (set_local $ip (i32.sub (local.get $top) (i32.const 2)))
      )
    )

    (return (local.get $ip))
  ) ;; end $loop


  ;; An if else conditional statement
  ;;
  (func $switch
    (param $opCodeAddress i32)
    (param $arg0Address i32)
    (param $arg1Address i32)
    (param $ip i32)
    (result i32)

    (local $branch i32) ;; the value of op(lhs, rhs) --
                        ;; determines which address to return

    ;; evaluate the branch condition
    (set_local $branch
      (call $binop
        (local.get $opCodeAddress)
        (local.get $arg0Address)
        (local.get $arg1Address)
      )
    )

    ;; determine which branch to execute
    (if (i32.eq (local.get $branch) (i32.const 0))
      (then
        ;; return ip -> "else" branch
        (return
          (i32.add
            (local.get $ip)
            (i32.load8_u (local.get $ip)) ;; ip offset
          )
        )
      )
    )
    ;; return ip -> "if" branch
    (return (i32.add (local.get $ip) (i32.const 1)))

  ) ;; end $switch


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
