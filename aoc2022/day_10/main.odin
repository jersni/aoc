package main
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:container/small_array"
import h "../helpers"
import "core:slice"

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

    /*
RJERPEFC
###....##.####.###..###..####.####..##..
#..#....#.#....#..#.#..#.#....#....#..#.
#..#....#.###..#..#.#..#.###..###..#....
###.....#.#....###..###..#....#....#....
#.#..#..#.#....#.#..#....#....#....#..#.
#..#..##..####.#..#.#....####.#.....##..
    */
}

State :: struct {
	cycle: int,
	x:     int,
}

part1 :: proc(lines: []string) {
	cycles := make([dynamic]State)
	defer delete(cycles)
	cycle := 0
	x := 1
	for instruction in lines {
		data := strings.split(instruction, " ")
		switch data[0] {
		case "noop":
			cycle += 1
			append(&cycles, State{cycle, x})
		case "addx":
			cycle += 1
			append(&cycles, State{cycle, x})
			cycle += 1
			append(&cycles, State{cycle, x})
			x += strconv.atoi(data[1])
		}

	}
	signal_strength: int
	for c := 20; c <= 220; c += 40 {
		s := cycles[c - 1]

		ss := s.x * s.cycle
		signal_strength += ss
		fmt.println(s, ss, signal_strength)
	}
	fmt.println("Part 1: ", signal_strength)

	for row := 0; row < 6; row += 1 {
		for pos := 0; pos < 40; pos += 1 {
			s := cycles[40 * row + pos]
			if pos == s.x || pos - 1 == s.x || pos + 1 == s.x {
				fmt.print("#")
			} else {
				fmt.print(".")
			}
		}
		fmt.println()
	}
}
