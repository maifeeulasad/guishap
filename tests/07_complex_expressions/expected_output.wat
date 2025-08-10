(module
  (global $a (mut i32) (i32.const 0))
  (global $result (mut i32) (i32.const 0))
  (func $main (result i32)
    ;; Assignment
    i32.const 10
    global.set $a
    ;; Assignment
    global.get $a
    global.get $b
    global.get $b
    i32.mul
    i32.const 3
    i32.const 3
    i32.add
    global.set $result
    i32.const 0
  )
  (export "main" (func $main))
)
