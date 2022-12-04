package main
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"
import h "../helpers"

main :: proc() {
	data := h.read_file("input.txt")
	defer delete(data)

	lines := strings.split_lines(string(data))
	elves := make([dynamic]int, 0, len(lines))
	defer delete(elves)

	sum := 0
	for line in lines {
		if len(line) == 0 {
			append(&elves, sum)

			sum = 0

		} else {
			sum += strconv.atoi(line)
		}
	}

	slice.reverse_sort(elves[:])

	fmt.println("Part 1", elves[0])
	fmt.println("Part 2", elves[0] + elves[1] + elves[2])

}

