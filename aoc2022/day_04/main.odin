package main
import "core:fmt"
import "core:strings"
import "core:strconv"
import h "../helpers"

main :: proc() {
	when 1 == 2 do file := "sample_input.txt"
	when 1 == 1 do file := "input.txt"
	data := h.read_file(file)
	defer delete(data)

	lines := strings.split_lines(string(data))
	defer delete(lines)

	// count # full overlap / count any overlap
	part1_and_2(lines)
}

part1_and_2 :: proc(lines: []string) {
	result1 := 0
	result2 := 0
	assignments := make([dynamic]Assignment, 0, len(lines) * 2)
	defer delete(assignments)
	for line in lines {
		pairs := strings.split(line, ",")
		defer delete(pairs)
		if len(pairs) < 2 do continue
		for pair in pairs {
			a := strings.split(pair, "-")
			defer delete(a)
			append(&assignments, Assignment{strconv.atoi(a[0]), strconv.atoi(a[1])})
		}
	}

	for i := 0; i < len(assignments); i += 2 {
		a := assignments[i]
		b := assignments[i + 1]
		if is_full_overlap(a, b) {
			result1 += 1
		}
		if is_any_overlap(a, b) {
			result2 += 1
		}
	}
	fmt.println("Part 1: ", result1)
	fmt.println("Part 2: ", result2)
}

Assignment :: struct {
	lo, hi: int,
}

is_full_overlap :: proc(a, b: Assignment) -> (result: bool) {
	longer, shorter: Assignment
	if a.hi - a.lo > b.hi - b.lo {
		longer, shorter = a, b
	} else {
		longer, shorter = b, a
	}

	if longer.lo <= shorter.lo && longer.hi >= shorter.hi {
		result = true
	}

	return
}

is_any_overlap :: proc(a, b: Assignment) -> (result: bool) {
	outer: for i := a.lo; i <= a.hi; i += 1 {
		for j := b.lo; j <= b.hi; j += 1 {
			if i == j {
				result = true
				break outer
			}
		}
	}
	return
}
