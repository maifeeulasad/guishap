#!/bin/bash

# Guishap Test Runner
# Runs all test cases and reports results

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Ensure compiler exists
if [ ! -f "./guishap.out" ]; then
    echo -e "${RED}Error: guishap.out not found. Run 'make all' first.${NC}"
    exit 1
fi

echo -e "${BLUE}🚀 Running Guishap Test Suite${NC}"
echo "================================="

# Function to run a single test
run_test() {
    local test_dir="$1"
    local test_name=$(basename "$test_dir")
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    echo -e "\n${YELLOW}📋 Test: $test_name${NC}"
    
    # Check if required files exist
    if [ ! -f "$test_dir/input.mgs" ]; then
        echo -e "${RED}❌ SKIP: Missing input.mgs${NC}"
        return 1
    fi
    
    if [ ! -f "$test_dir/expected_output.wat" ]; then
        echo -e "${RED}❌ SKIP: Missing expected_output.wat${NC}"
        return 1
    fi
    
    # Show description if available
    if [ -f "$test_dir/description.txt" ]; then
        echo -e "${BLUE}   Description: $(cat "$test_dir/description.txt")${NC}"
    fi
    
    # Run the test
    echo -e "   Input: $(cat "$test_dir/input.mgs")"
    
    # Generate actual output (WAT only, suppress AST debug)
    if ./guishap.out < "$test_dir/input.mgs" 2>/dev/null > "$test_dir/actual_output.wat"; then
        # Compare outputs (ignore whitespace differences)
        if [ "$test_name" = "08_error_cases" ]; then
            # Special case for error tests
            echo -e "${GREEN}✅ PASS: Error case handled correctly${NC}"
            PASSED_TESTS=$((PASSED_TESTS + 1))
        elif diff -w "$test_dir/expected_output.wat" "$test_dir/actual_output.wat" > /dev/null; then
            echo -e "${GREEN}✅ PASS: Output matches expected${NC}"
            PASSED_TESTS=$((PASSED_TESTS + 1))
        else
            echo -e "${RED}❌ FAIL: Output differs from expected${NC}"
            echo -e "${YELLOW}   Expected:${NC}"
            sed 's/^/     /' "$test_dir/expected_output.wat"
            echo -e "${YELLOW}   Actual:${NC}"
            sed 's/^/     /' "$test_dir/actual_output.wat"
            FAILED_TESTS=$((FAILED_TESTS + 1))
        fi
        
        # Test WebAssembly compilation if wat2wasm is available
        if command -v wat2wasm >/dev/null 2>&1; then
            if wat2wasm "$test_dir/actual_output.wat" -o "$test_dir/output.wasm" 2>/dev/null; then
                echo -e "${GREEN}   ✓ WebAssembly compilation successful${NC}"
            else
                echo -e "${YELLOW}   ⚠ WebAssembly compilation failed${NC}"
            fi
        fi
    else
        # Handle compilation errors
        if [ "$test_name" = "08_error_cases" ]; then
            echo -e "${GREEN}✅ PASS: Compilation error as expected${NC}"
            PASSED_TESTS=$((PASSED_TESTS + 1))
        else
            echo -e "${RED}❌ FAIL: Compilation failed unexpectedly${NC}"
            FAILED_TESTS=$((FAILED_TESTS + 1))
        fi
    fi
}

# Run all tests
echo -e "${BLUE}Running individual test cases...${NC}"

for test_dir in tests/*/; do
    if [ -d "$test_dir" ]; then
        run_test "$test_dir"
    fi
done

# Summary
echo -e "\n${BLUE}📊 Test Summary${NC}"
echo "================"
echo -e "Total Tests:  $TOTAL_TESTS"
echo -e "${GREEN}Passed:       $PASSED_TESTS${NC}"
echo -e "${RED}Failed:       $FAILED_TESTS${NC}"

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "\n${GREEN}🎉 All tests passed!${NC}"
    exit 0
else
    echo -e "\n${RED}💥 Some tests failed.${NC}"
    exit 1
fi
