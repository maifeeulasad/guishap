(module
  (global $x (mut i32) (i32.const 0))
  (func $main (result i32)
    ;; Assignment
    i32.const 5
    global.set $x
    i32.const 0
  )
  (export "main" (func $main))
)
