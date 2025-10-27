(module
  (global $x (mut i32) (i32.const 0))
  (global $y (mut i32) (i32.const 0))
  (global $eq_result (mut i32) (i32.const 0))
  (global $ne_result (mut i32) (i32.const 0))
  (func $main (result i32)
    ;; Assignment
    i32.const 5
    global.set $x
    ;; Assignment
    i32.const 10
    global.set $y
    ;; Assignment
    global.get $x
    global.get $x
    i32.eq
    global.set $eq_result
    ;; Assignment
    global.get $x
    global.get $y
    i32.ne
    global.set $ne_result
    i32.const 0
  )
  (export "main" (func $main))
)
