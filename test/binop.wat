;; compute ((7*5)-2)
(func $setup
  ;; instruction 0
  (i32.store8 (i32.const 0) (i32.const 1))   ;; instruction type: binop
  (i32.store8 (i32.const 1) (i32.const 42))  ;; store result at address 42
  (i32.store8 (i32.const 2) (i32.const 2))   ;; opcode: mul
  (i32.store8 (i32.const 3) (i32.const 39))  ;; lhs: value stored at address 39
  (i32.store8 (i32.const 4) (i32.const 40))  ;; rhs: value stored at address 40

  ;; instruction 1
  (i32.store8 (i32.const 5) (i32.const 1))   ;; instruction type: binop
  (i32.store8 (i32.const 6) (i32.const 42))  ;; store result at address 42
  (i32.store8 (i32.const 7) (i32.const 1))   ;; opcode: sub
  (i32.store8 (i32.const 8) (i32.const 42))  ;; lhs: value stored at address 42
  (i32.store8 (i32.const 9) (i32.const 41))  ;; rhs: value stored at address 41

  ;; setup predefined values for the "variables"
  (i32.store8 (i32.const 39) (i32.const 5))
  (i32.store8 (i32.const 40) (i32.const 7))
  (i32.store8 (i32.const 41) (i32.const 2))
)
