package main
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:container/small_array"
import h "../helpers"

SAMPLE :: false
when SAMPLE {
	file := "sample_input.txt"

}
when !SAMPLE {
	file := "input.txt"

}

main :: proc() {
	data := h.read_file(file)
	defer delete(data)

	lines := strings.split_lines(string(data))
	defer delete(lines)

	part1(lines)

}

part1 :: proc(lines: []string) {
	fmt.println("Ok", lines)
}
