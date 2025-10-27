# guishap - জনসাধারণ সুলভ বাংলা প্রোগ্রামিং ল্যাঙ্গুয়েজ

**Guishap** (গুইশাপ) is a Bengali programming language that compiles to WebAssembly, making programming accessible in native Bengali language.

## 🎯 Language Features

### Functionality Status Table

| **Category** | **Feature** | **Bengali Syntax** | **English Example** | **Status** | **Notes** |
|-------------|-------------|-------------------|-------------------|-----------|----------|
| **Data Types & Variables** |
| | Integer Variables | `সংখ্যা x` | `number x` | ⚠️ **PARTIAL** | Token exists, grammar TODO |
| | String Variables | `স্ট্রিং x` | `string x` | ⚠️ **PARTIAL** | Token exists, grammar TODO |
| | Constants | `ধ্রুবক সংখ্যা x` | `const number x` | ⚠️ **PARTIAL** | Token exists, grammar TODO |
| | Assignment | `x = 123` | `x = 123` | ✅ **DONE** | Working with integers & strings |
| **Numeric System** |
| | Bengali Numerals | `৫, ১০, ১২৩` | `5, 10, 123` | ✅ **DONE** | Converts ০১২৩৪৫৬৭৮৯ → 0123456789 |
| | English Numerals | `5, 10, 123` | `5, 10, 123` | ✅ **DONE** | Standard numeric literals |
| **Mathematical Operations** |
| | Addition | `x + y` | `x + y` | ✅ **DONE** | WebAssembly i32.add |
| | Subtraction | `x - y` | `x - y` | ✅ **DONE** | WebAssembly i32.sub |
| | Multiplication | `x * y` | `x * y` | ✅ **DONE** | WebAssembly i32.mul |
| | Division | `x / y` | `x / y` | ✅ **DONE** | WebAssembly i32.div_s |
| | Complex Expressions | `result = a + b * c` | `result = a + b * c` | ✅ **DONE** | Operator precedence working |
| **Comparison Operations** |
| | Equality | `x == y` | `x == y` | ⚠️ **PARTIAL** | Grammar exists, codegen TODO |
| | Inequality | `x != y` | `x != y` | ⚠️ **PARTIAL** | Grammar exists, codegen TODO |
| **Control Flow** |
| | If Statement | `যদি x == y:` | `if x == y:` | ⚠️ **PARTIAL** | Grammar exists, needs testing |
| | Else Statement | `নাহলে:` | `else:` | ⚠️ **PARTIAL** | Grammar exists, needs testing |
| | For Loop | `জন্য x in list:` | `for x in list:` | ⚠️ **PARTIAL** | Grammar exists, needs work |
| | While Loop | `যেহেতু x < 10:` | `while x < 10:` | ❌ **TODO** | Token exists, grammar TODO |
| **Functions** |
| | Function Definition | `ফাংশন নাম():` | `function name():` | ⚠️ **PARTIAL** | Basic grammar, no parameters |
| | Function Parameters | `ফাংশন যোগ(a, b):` | `function add(a, b):` | ❌ **TODO** | Parameter support needed |
| | Return Statement | `ফেরত x` | `return x` | ⚠️ **PARTIAL** | Grammar exists, codegen TODO |
| **Classes** |
| | Class Definition | `শ্রেণী নাম:` | `class name:` | ⚠️ **PARTIAL** | Grammar exists, codegen TODO |
| **String Operations** |
| | String Literals | `"হ্যালো ওয়ার্ল্ড"` | `"Hello World"` | ⚠️ **PARTIAL** | Basic support, length only |
| | String Concatenation | `str1 + str2` | `str1 + str2` | ❌ **TODO** | String operations needed |
| **Identifiers** |
| | Bengali Identifiers | `নাম, বয়স, পরিমাপ` | `name, age, measure` | ✅ **DONE** | Unicode Bengali support |
| | English Identifiers | `name, age, count` | `name, age, count` | ✅ **DONE** | ASCII identifiers |
| **Build System** |
| | Compilation | `make all` | - | ✅ **DONE** | Builds lexer, parser, codegen |
| | Testing | `make test` | - | ✅ **DONE** | Automated test suite |
| | WebAssembly | `make test-wasm` | - | ✅ **DONE** | Generates .wasm files |
| **Code Generation** |
| | WebAssembly Text | `.wat` output | - | ✅ **DONE** | Clean WAT generation |
| | WebAssembly Binary | `.wasm` output | - | ✅ **DONE** | Binary WebAssembly |
| | Global Variables | `global $var` | - | ✅ **DONE** | Automatic global detection |

### Status Legend

- ✅ **DONE**: Fully implemented and tested
- ⚠️ **PARTIAL**: Basic implementation exists, needs enhancement
- ❌ **TODO**: Not yet implemented

## 📝 Usage Examples

### Current Working Features

#### Basic Assignment
```bengali
x = ৫
y = 10
z = "হ্যালো"
```

#### Arithmetic Operations  
```bengali
result = ৫ + ৩ * ২
difference = abc - xyz
```

#### Mixed Bengali-English
```bengali
বয়স = 25
নাম = "মায়ফী"
total = বয়স + 5
```

### Planned Features (TODO)

#### Variable Declaration
```bengali
সংখ্যা x = ১২৩
স্ট্রিং নাম = "বাংলা"
ধ্রুবক সংখ্যা পাই = ৩.১৪
```

#### Control Flow
```bengali
যদি x > ৫:
    result = "বড়"
নাহলে:
    result = "ছোট"

জন্য i in range(১০):
    print(i)
```

#### Functions
```bengali
ফাংশন যোগ(a, b):
    ফেরত a + b

ফাংশন নমস্কার(নাম):
    ফেরত "হ্যালো " + নাম
```

## 🚀 Getting Started

### Prerequisites
```bash
sudo apt install flex bison wat2wasm -y
```

### Build & Test
```bash
# Build the compiler
make all

# Run tests
make test

# Generate WebAssembly
make test-wasm

# Compile your own code
echo "x = ৫ + ৩" | ./guishap.out > myprogram.wat
wat2wasm myprogram.wat -o myprogram.wasm
```

## 🎯 Next Steps

**High Priority TODO:**
1. **Variable Declaration Grammar** - Implement `সংখ্যা x` syntax
2. **Function Parameters** - Support `ফাংশন নাম(a, b)`  
3. **Control Flow Testing** - Complete if/else/for implementation
4. **String Operations** - Proper string handling and concatenation
5. **Constants** - Implement `ধ্রুবক` keyword functionality

**Medium Priority:**
- While loops (`যেহেতু`)
- Class definitions (`শ্রেণী`)
- Comparison operators in expressions
- Better error messages in Bengali

**Low Priority:**
- Advanced string methods
- Array/list support
- Import/export system
- Standard library functions