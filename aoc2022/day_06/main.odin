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

	part1(lines)

}

part1 :: proc(lines: []string) {
	fmt.println("Ok", lines)
}
