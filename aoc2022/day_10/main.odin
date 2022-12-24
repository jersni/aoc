package main
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:container/small_array"
import h "../helpers"
import "core:slice"

SAMPLE :: true
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
	// addx V takes two cycles. after 2, update x by V
	// noop takes one cycle
}

/*
noop
addx 3
addx -5

Execution of this program proceeds as follows:

    At the start of the first cycle, the noop instruction begins execution. During the first cycle, X is 1. After the
    first cycle, the noop instruction finishes execution, doing nothing.
   
    At the start of the second cycle, the addx 3 instruction begins execution. During the second cycle, X is still 1.
    During the third cycle, X is still 1. After the third cycle, the addx 3 instruction finishes execution, setting
    X to 4.
   
    At the start of the fourth cycle, the addx -5 instruction begins execution. During the fourth cycle, X is still 4.
   
    During the fifth cycle, X is still 4. After the fifth cycle, the addx -5 instruction finishes execution, setting 
    X to -1.

Signal strenght = X * cycle

The sum of these signal strengths for the example data is 13140.

Find the signal strength during the 20th, 60th, 100th, 140th, 180th, and 220th cycles. What is the sum of these six 
signal strengths?
*/
