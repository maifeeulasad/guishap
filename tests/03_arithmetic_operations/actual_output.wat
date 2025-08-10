(module
  (global $result (mut i32) (i32.const 0))
  (func $main (result i32)
    ;; Assignment
    i32.const 5
    i32.const 3
    i32.const 3
    i32.add
    global.set $result
    i32.const 0
  )
  (export "main" (func $main))
)
