package main
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:container/small_array"
import h "../helpers"

MAX_STACK_SIZE :: 100

main :: proc() {
	when 1 == 2 do file := "sample_input.txt"
	when 1 == 1 do file := "input.txt"
	data := h.read_file(file)
	defer delete(data)

	lines := strings.split_lines(string(data))
	defer delete(lines)

	part1(lines[0], 4)
	part1(lines[0], 14)

}

part1 :: proc(line: string, window_size := 4) {
	window_index := 0
	window := line[0:window_size]
	seen := make(map[rune]rune)
	outer: for {
		inner: for r in window {
			if r in seen {
				if window_index + 1 >= len(line) do break outer
				for k in window {
					delete_key(&seen, k)
				}
				window_index += 1
				window = line[window_index:window_index + window_size]
				continue outer
			} else {
				seen[r] = r
			}
		}
		break outer
	}
	fmt.println("Part 1: ", window_index + window_size)
}
