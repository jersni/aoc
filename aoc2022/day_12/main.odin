package main
import "core:fmt"
import "core:strings"
import "core:container/priority_queue"
import h "../helpers"

INF :: 9999999

SAMPLE :: false
when SAMPLE {
	file := "sample_input.txt"
	ROWS :: 5
	COLS :: 8

}
when !SAMPLE {
	file := "input.txt"
	ROWS :: 41
	COLS :: 171


}

V :: ROWS * COLS

graph: [V][V]bool

squares := [ROWS][COLS]Square{}

Queue :: priority_queue.Priority_Queue(^Square)

main :: proc() {
	data := h.read_file(file)
	defer delete(data)

	lines := strings.split_lines(string(data))
	defer delete(lines)

	part1(lines)
}


less :: proc(a, b: ^Square) -> bool {
	return a.d < b.d
}
part1 :: proc(lines: []string) {

	queue := Queue{}
	priority_queue.init(&queue, less, priority_queue.default_swap_proc(^Square))

	// init from input
	{
		line := 0
		for r, x in squares {
			for c, y in r {
				ch := rune(lines[line][y])
				d := INF
				if ch == 'S' {
					ch = 'a'
					squares[x][y].is_start = true
					d = 0
				} else if ch == 'E' {
					ch = 'z'
					squares[x][y].is_end = true
				}
				squares[x][y].elevation = ch
				squares[x][y].x = x
				squares[x][y].y = y
				squares[x][y].id = x * COLS + y
				squares[x][y].d = d
				squares[x][y].value = 1

				priority_queue.push(&queue, &squares[x][y])
			}
			line += 1
		}
	}

	// build the graph
	{
		for r, x in squares {
			for c, y in r {
				s := squares[x][y]
				if x > 0 {
					// left
					t := squares[x - 1][y]
					graph[s.id][t.id] = can_move(s.elevation, t.elevation)
				}
				if y > 0 {
					// up
					t := squares[x][y - 1]
					graph[s.id][t.id] = can_move(s.elevation, t.elevation)
				}
				if x < ROWS - 1 {
					// right
					t := squares[x + 1][y]
					graph[s.id][t.id] = can_move(s.elevation, t.elevation)
				}
				if y < COLS - 1 {
					// down
					t := squares[x][y + 1]
					graph[s.id][t.id] = can_move(s.elevation, t.elevation)
				}

			}
		}
	}

	// dijkstra / shortest path
	weight := 1
	s := make(map[int]^Square)
	outer: for priority_queue.len(queue) > 0 {
		u := priority_queue.pop(&queue)
		s[u.id] = u

		if u.is_end {
			fmt.println("Part 1:", u.d)
			break outer
		}

		for r, x in squares {
			for sq, y in r {
				if adjacent(u.id, sq.id) {
					alt := u.d + weight
					if sq.d > alt {
						squares[x][y].d = alt
						squares[x][y].pred = u
						for item, i in queue.queue {
							if item.id == sq.id {
								priority_queue.fix(&queue, i)
								break
							}
						}
					}
				}
			}
		}
	}
}

adjacent :: proc(i, j: int) -> (result: bool) {
	result = graph[i][j]
	return
}

can_move :: proc(from, to: rune) -> (result: bool) {
	source := int(from)
	dest := int(to)
	if dest < source {
		// fmt.print(" ok, move to lower ")
		result = true
	} else {
		result = dest - source <= 1
	}
	return
}

Square :: struct {
	id:        int,
	x:         int,
	y:         int,
	elevation: rune,
	value:     int,
	is_start:  bool,
	is_end:    bool,
	d:         int,
	pred:      ^Square,
}
