package main
import "core:fmt"
import "core:strings"
import "core:slice"
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


Graph :: [V][V]bool
graph: Graph
squares := [ROWS][COLS]Square{}

Queue :: priority_queue.Priority_Queue(^Square)

main :: proc() {
	data := h.read_file(file)
	defer delete(data)

	lines := strings.split_lines(string(data))
	defer delete(lines)

	part1(lines)
	part2(lines)
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
				squares[x][y].id = x * COLS + y
				squares[x][y].d = d

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
            fmt.println("Part 1: ", u.d)
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

Grid :: [ROWS][COLS]Square

init_grid :: proc(lines: []string) {
	line := 0
	for r, x in grid {
		for c, y in r {
			ch := rune(lines[line][y])
			grid[x][y].id = x * COLS + y
			if ch == 'S' {
				ch = 'a'
			} else if (ch == 'E') {
				ch = 'z'
				grid[x][y].is_end = true
			}
			grid[x][y].elevation = ch
		}
		line += 1
	}
}

init_graph :: proc() {
	for r, x in grid {
		for c, y in r {
			s := grid[x][y]
			if x > 0 {
				// left
				t := grid[x - 1][y]
				graph[s.id][t.id] = can_move2(s.elevation, t.elevation)
			}
			if y > 0 {
				// up
				t := grid[x][y - 1]
				graph[s.id][t.id] = can_move2(s.elevation, t.elevation)
			}
			if x < ROWS - 1 {
				// right
				t := grid[x + 1][y]
				graph[s.id][t.id] = can_move2(s.elevation, t.elevation)
			}
			if y < COLS - 1 {
				// down
				t := grid[x][y + 1]
				graph[s.id][t.id] = can_move2(s.elevation, t.elevation)
			}

		}
	}
}

grid: Grid
part2 :: proc(lines: []string) {
	init_grid(lines)

	init_graph()

	start := get_start()

	queue := Queue{}
	priority_queue.init(&queue, less, priority_queue.default_swap_proc(^Square))

	for r, x in grid {
		for s, y in r {
			if s.id == start {
				grid[x][y].d = 0
				grid[x][y].is_start = true
			} else {
				grid[x][y].d = INF
			}
			priority_queue.push(&queue, &grid[x][y])
		}
	}

	paths := solve(&queue)
	defer delete(paths)
    min := INF
	for k, v in paths {
		if v.elevation == 'a' {
            if v.d < min {
                min = v.d
            }
        }
	}

    fmt.println("Part 2: ", min)

}

solve :: proc(q: ^Queue) -> map[int]^Square {
	weight := 1
	s := make(map[int]^Square)

	outer: for priority_queue.len(q^) > 0 {
		u := priority_queue.pop(q)
		s[u.id] = u

		for r, x in grid {
			for sq, y in r {
				if adjacent(u.id, sq.id) {
					alt := u.d + weight
					if sq.d > alt {
						grid[x][y].d = alt
						grid[x][y].pred = u
						for item, i in q.queue {
							if item.id == sq.id {
								priority_queue.fix(q, i)
								break
							}
						}
					}
				}
			}
		}
	}

	return s
}


get_start :: proc() -> int {
	for r in grid {
		for s in r {
			if s.is_end {
				return s.id
			}
		}
	}
	panic("could not find the start?")
}

adjacent :: proc(i, j: int) -> (result: bool) {
	result = graph[i][j]
	return
}

can_move :: proc(from, to: rune) -> (result: bool) {
	source := int(from)
	dest := int(to)
	if dest < source {
		result = true
	} else {
		result = dest - source <= 1
	}
	return
}

can_move2 :: proc(from, to: rune) -> (result: bool) {
	source := int(from)
	dest := int(to)
	if dest > source {
		result = true
	} else {
		result = source - dest <= 1
	}
	return
}


Square :: struct {
	id:        int,
	elevation: rune,
	is_start:  bool,
	is_end:    bool,
	d:         int,
	pred:      ^Square,
}
