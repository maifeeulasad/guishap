(module
  (global $abc (mut i32) (i32.const 0))
  (global $xyz (mut i32) (i32.const 0))
  (func $main (result i32)
    ;; Assignment
    i32.const 25
    global.set $abc
    ;; Assignment
    i32.const 100
    global.set $xyz
    i32.const 0
  )
  (export "main" (func $main))
)
