package main
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:container/small_array"
import h "../helpers"
import "core:mem"

SAMPLE :: false
when SAMPLE {
	file := "sample_input.txt"
	rows, cols :: 5, 5
}
when !SAMPLE {
	file := "input.txt"
	rows, cols :: 99, 99
}

main :: proc() {
	data := h.read_file(file)
	defer delete(data)

	lines := strings.split_lines(string(data))
	defer delete(lines)

	build_grid(lines)
	part1()
	part2()


}
grid := [rows][cols]Tree{}
build_grid :: proc(lines: []string) {
	for line, row in lines {
		for r, col in line {
			if row == 0 || col == 0 || row == rows - 1 || col == cols - 1 {
				grid[row][col] = Tree{int(r - '0'), true, [?]int{0, 0, 0, 0}, 0}
			} else {
				grid[row][col] = Tree{int(r - '0'), false, [?]int{0, 0, 0, 0}, 0}
			}
		}
	}
}

part1 :: proc() {
	for r := 1; r < rows - 1; r += 1 {
		// scan left to right
		{
			highest := grid[r][0].height
			for c := 1; c < cols - 1; c += 1 {
				if current_height := grid[r][c].height; current_height > highest {
					highest = current_height
					grid[r][c].visible = true
				} else {
					grid[r][c].visible = grid[r][c].visible || false
				}

			}
		}
		// scan right to left
		{
			highest := grid[r][cols - 1].height
			for c := cols - 1; c > 0; c -= 1 {
				if current_height := grid[r][c].height; current_height > highest {
					highest = current_height
					grid[r][c].visible = true
				} else {
					grid[r][c].visible = grid[r][c].visible || false
				}

			}
		}

	}

	for c := 1; c < cols - 1; c += 1 {
		// scan top to bottom
		{
			highest := grid[0][c].height
			for r := 1; r < rows - 1; r += 1 {
				if current_height := grid[r][c].height; current_height > highest {
					highest = current_height
					grid[r][c].visible = true
				} else {
					grid[r][c].visible = grid[r][c].visible || false
				}
			}
		}
		// scan bottom to top
		{
			highest := grid[rows - 1][c].height
			for r := rows - 1; r > 0; r -= 1 {
				if current_height := grid[r][c].height; current_height > highest {
					highest = current_height
					grid[r][c].visible = true
				} else {
					grid[r][c].visible = grid[r][c].visible || false
				}
			}
		}
	}

	visible := 0
	for r, x in grid {
		for c, y in r {
			if c.visible {
				visible += 1
			}
		}
	}

	fmt.println("Part 1: ", visible)

}

part2 :: proc() {
	// viewing distance from a given tree, 
	// look up, down, left, and right from that tree; 
	// stop if you reach an edge or at the first tree 
	// that is the same height or taller than the tree under consideration
	for row, r in grid {
		for col, c in row {
			my_height := grid[r][c].height
			// up
			{
				score := 0
				i := r - 1
				for i >= 0 {
					score += 1
					if grid[i][c].height >= my_height do break
					i -= 1
				}
				grid[r][c].score[0] = score
			}

			// left
			{
				score := 0
				i := c - 1
				for i >= 0 {
					score += 1
					if grid[r][i].height >= my_height do break
					i -= 1
				}
				grid[r][c].score[1] = score

			}
			// right
			{
				score := 0
				i := c + 1
				for i < cols {
					score += 1
					if grid[r][i].height >= my_height do break
					i += 1
				}
				grid[r][c].score[2] = score

			}

			// down
			{
				score := 0
				i := r + 1
				for i < rows {
					score += 1
					if grid[i][c].height >= my_height do break
					i += 1
				}
				grid[r][c].score[3] = score

			}

		}
	}

	for r, i in grid {
		for c, j in r {
			grid[i][j].scenic_score = scenic_score(grid[i][j].score[:])
		}
	}

	highest_scenic_score := 0
	for r, i in grid {
		for c, j in r {
			if c.scenic_score > highest_scenic_score {
				highest_scenic_score = c.scenic_score
			}

		}
	}
	// score :: up, left, right, down

	fmt.println("Part 2: ", highest_scenic_score)
}

Tree :: struct {
	height:       int,
	visible:      bool,
	score:        [4]int,
	scenic_score: int,
}

import "core:slice"

mult :: proc(a, b: int) -> int {
	return a * b
}
scenic_score :: proc(ints: []int) -> (score: int) {
	score = slice.reduce(ints, 1, mult)
	return
}
