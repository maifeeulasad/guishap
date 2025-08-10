(module
  (global $message (mut i32) (i32.const 0))
  (func $main (result i32)
    ;; Assignment
    i32.const 5  ;; String length of "hello"
    global.set $message
    i32.const 0
  )
  (export "main" (func $main))
)
