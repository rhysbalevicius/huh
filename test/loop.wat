;; while m[42] < m[39]: m[42] = m[42] + m[41]
(func $setup
  ;; loop definition
  (i32.store8 (i32.const 0) (i32.const 4))   ;; instruction type: loop
  (i32.store8 (i32.const 1) (i32.const 2))   ;; number of instructions in loop body
  (i32.store8 (i32.const 2) (i32.const 40))  ;; halt address

  ;; instruction 0
  (i32.store8 (i32.const 3) (i32.const 1))   ;; binop
  (i32.store8 (i32.const 4) (i32.const 42))  ;; store result at address 42
  (i32.store8 (i32.const 5) (i32.const 0))   ;; opcode: add
  (i32.store8 (i32.const 6) (i32.const 42))  ;; lhs: stored at address 42
  (i32.store8 (i32.const 7) (i32.const 41))  ;; rhs: stored at address 41

  ;; instruction 1
  (i32.store8 (i32.const 8) (i32.const 1))   ;; binop
  (i32.store8 (i32.const 9) (i32.const 40))  ;; store result at address 40
  (i32.store8 (i32.const 10) (i32.const 18)) ;; opcode: lt_u
  (i32.store8 (i32.const 11) (i32.const 42)) ;; lhs: stored at address 42
  (i32.store8 (i32.const 12) (i32.const 39)) ;; rhs: stored at address 39

  ;; setup predefined values for the "variables"
  (i32.store8 (i32.const 39) (i32.const 255))
  (i32.store8 (i32.const 41) (i32.const 1))
)
