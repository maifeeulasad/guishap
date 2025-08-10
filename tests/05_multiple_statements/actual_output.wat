(module
  (global $x (mut i32) (i32.const 0))
  (global $y (mut i32) (i32.const 0))
  (func $main (result i32)
    ;; Assignment
    i32.const 123
    global.set $x
    ;; Assignment
    i32.const 456
    global.set $y
    i32.const 0
  )
  (export "main" (func $main))
)
