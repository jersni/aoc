package main
import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:slice"

main :: proc() {
	data := read_file("input.txt")
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

read_file :: proc(filepath: string, allocator := context.allocator) -> []byte {
	context.allocator = allocator
	data, ok := os.read_entire_file(filepath)
	if !ok {
		panic("could not read file")
	}

	return data
}
