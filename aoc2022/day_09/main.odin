package main
import "core:fmt"
import "core:math"
import "core:strings"
import "core:strconv"
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

	part1 := solve(lines, 2)
	part2 := solve(lines, 10)

	fmt.println("Part 1: ", part1)
	fmt.println("Part 2: ", part2)
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


solve :: proc(lines: []string, $RopeLenght: int) -> int {
	s := Pos{0, 0}
	rope := [RopeLenght]Pos{}
	rope = s

	visited := make(map[Pos]bool)
	visited[s] = true

	for l in lines {
		dir, reps := parse_dir_and_reps(l)
		for i in 0 ..< reps {
			switch dir {
			case Dir.u:
				rope[0].y += 1
			case Dir.r:
				rope[0].x += 1
			case Dir.d:
				rope[0].y -= 1
			case Dir.l:
				rope[0].x -= 1
			}

			for j := 1; j < len(rope); j += 1 {
				diff_x := math.abs(rope[j - 1].x - rope[j].x)
				diff_y := math.abs(rope[j - 1].y - rope[j].y)

				if diff_x > 1 || diff_y > 1 {
					dx, dy := 0, 0
					if rope[j - 1].x - rope[j].x > 0 {
						dx = 1
					} else if rope[j - 1].x - rope[j].x < 0 {
						dx = -1
					}

					if rope[j - 1].y - rope[j].y > 0 {
						dy = 1
					} else if rope[j - 1].y - rope[j].y < 0 {
						dy = -1
					}


					rope[j].x += dx
					rope[j].y += dy
					if j == len(rope) - 1 {
						visited[rope[j]] = true
					}
				}
			}
		}
	}

	return len(visited)
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
