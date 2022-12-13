package main
import "core:fmt"
import "core:math"
import "core:strings"
import "core:strconv"
import h "../helpers"

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


Pos :: struct {
	x, y: int,
}
Dir :: enum {
	u,
	r,
	d,
	l,
}
part1 :: proc(lines: []string) {
	s := Pos{0, 0}
	h := s
	h_last := s
	t := s
	visited := make(map[Pos]bool)
	visited[t] = true

	for l in lines {
		dir, reps := parse_dir_and_reps(l)
		for i in 0 ..< reps {
			h_last = h
			switch dir {
			case Dir.u:
				h.y += 1
			case Dir.r:
				h.x += 1
			case Dir.d:
				h.y -= 1
			case Dir.l:
				h.x -= 1
			}

			if math.abs(h.x - t.x) > 1 || math.abs(h.y - t.y) > 1 {
				t.x = h_last.x
				t.y = h_last.y
				visited[t] = true
			}
		}
	}


	fmt.println("Part 1: ", len(visited))
}

parse_dir_and_reps :: proc(data: string) -> (dir: Dir, reps: int) {
	parts := strings.split(data, " ")
	defer delete(parts)

	switch parts[0] {
	case "U":
		dir = .u
	case "R":
		dir = .r
	case "D":
		dir = .d
	case "L":
		dir = .l
	}
	reps = strconv.atoi(parts[1])
	return
}
