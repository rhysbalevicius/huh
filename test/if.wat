;; if (m[39] < m[40]): m[42] = m[41] + m[41]
;; else: m[42] = m[42] * m[41]
(func $setup
  ;; if else definition
  (i32.store8 (i32.const 0) (i32.const 2))   ;; instruction type: if/else
  (i32.store8 (i32.const 1) (i32.const 18))  ;; opcode: lt_u
  (i32.store8 (i32.const 2) (i32.const 39))  ;; lhs: value stored at address 39
  (i32.store8 (i32.const 3) (i32.const 40))  ;; rhs: value stored at address 40
  (i32.store8 (i32.const 4) (i32.const 8))   ;; if block offset

  ;; instruction 0 "if"
  (i32.store8 (i32.const 5) (i32.const 1))   ;; instruction type: binop
  (i32.store8 (i32.const 6) (i32.const 42))  ;; store result at address 42
  (i32.store8 (i32.const 7) (i32.const 0))   ;; opcode: add
  (i32.store8 (i32.const 8) (i32.const 41))  ;; lhs: value stored at address 41
  (i32.store8 (i32.const 9) (i32.const 41))  ;; rhs: value stored at address 41

  ;; jump to end of "else"
  (i32.store8 (i32.const 10) (i32.const 3))  ;; instruction type: jump
  (i32.store8 (i32.const 11) (i32.const 6))  ;; jump to address 17

  ;; instruction 1 "else"
  (i32.store8 (i32.const 12) (i32.const 1))  ;; instruction type: binop
  (i32.store8 (i32.const 13) (i32.const 42)) ;; store result at address 42
  (i32.store8 (i32.const 14) (i32.const 2))  ;; opcode: mul
  (i32.store8 (i32.const 15) (i32.const 39)) ;; lhs: value stored at address 42
  (i32.store8 (i32.const 16) (i32.const 41)) ;; rhs: value stored at address 41

  ;; setup predefined values for the "variables"
  (i32.store8 (i32.const 39) (i32.const 5))
  (i32.store8 (i32.const 40) (i32.const 7))
  (i32.store8 (i32.const 41) (i32.const 2))
)
