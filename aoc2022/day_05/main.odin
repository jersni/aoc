package main
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:container/small_array"
import h "../helpers"

MAX_STACK_SIZE :: 100

main :: proc() {
	// input is the rearrangement procedure
	when 1 == 2 do file := "sample_input.txt"
	when 1 == 1 do file := "input.txt"
	data := h.read_file(file)
	defer delete(data)

	lines := strings.split_lines(string(data))
	defer delete(lines)

	part1(lines) // VQZNJMWTR
	part2(lines) // NLCDCLVMQ

}

part1 :: proc(lines: []string) {
	// find the line indexes of where the stacks start / end and instructions start / end
	stack_labels, stacks_start, stacks_end, instructions_start, instructions_end: int
	find_stack_end: bool
	for line, i in lines {
		if len(line) == 0 && !find_stack_end {
			stacks_end = i - 2
			instructions_start = i + 1
			find_stack_end = true
			stack_labels = i - 1
		} else if len(line) == 0 && find_stack_end {
			continue
		} else {
			instructions_end = i
		}
	}

	Stack :: small_array.Small_Array(MAX_STACK_SIZE, rune)
	stacks := make(map[int]Stack)

	{
		labels := strings.split(lines[stack_labels], " ")
		for l in labels {
			if len(l) == 0 do continue
			s := strconv.atoi(l)
			stacks[s] = Stack{}
		}
	}

	fmt.println(stacks_start, stacks_end, stack_labels, instructions_start, instructions_end)

	for i := stacks_end; i >= stacks_start; i -= 1 {
		line := lines[i]
		j := 1
		fmt.println(line)
		label := 1
		for j < len(line) {
			crate := rune(line[j])
			if crate != ' ' do small_array.push_front(&stacks[label], crate)
			label += 1
			j += 4
		}
	}


	// instructions will manipulate stacks
	// move 1 from 2 to 1
	for i := instructions_start; i <= instructions_end; i += 1 {
		move, from, to := move_from_to(lines[i])
		for n := 0; n < move; n += 1 {
			small_array.push_front(&stacks[to], small_array.pop_front(&stacks[from]))
		}
	}

	fmt.println("Part 1: ")
	for k, v in stacks {
		if small_array.len(v) > 0 {
			fmt.println(k, v.data[0])
		} else {
			fmt.println(k, ' ')
		}
	}

}

move_from_to :: proc(line: string) -> (move, from, to: int) {
	data := strings.split_multi(line, []string{"move ", "from ", "to "})
	move = strconv.atoi(data[1])
	from = strconv.atoi(data[2])
	to = strconv.atoi(data[3])
	return
}


part2 :: proc(lines: []string) {
	// find the line indexes of where the stacks start / end and instructions start / end
	stack_labels, stacks_start, stacks_end, instructions_start, instructions_end: int
	find_stack_end: bool
	for line, i in lines {
		if len(line) == 0 && !find_stack_end {
			stacks_end = i - 2
			instructions_start = i + 1
			find_stack_end = true
			stack_labels = i - 1
		} else if len(line) == 0 && find_stack_end {
			continue
		} else {
			instructions_end = i
		}
	}

	Stack :: small_array.Small_Array(MAX_STACK_SIZE, rune)
	stacks := make(map[int]Stack)

	{
		labels := strings.split(lines[stack_labels], " ")
		for l in labels {
			if len(l) == 0 do continue
			s := strconv.atoi(l)
			stacks[s] = Stack{}
		}
	}

	fmt.println(stacks_start, stacks_end, stack_labels, instructions_start, instructions_end)

	for i := stacks_end; i >= stacks_start; i -= 1 {
		line := lines[i]
		j := 1
		fmt.println(line)
		label := 1
		for j < len(line) {
			crate := rune(line[j])
			if crate != ' ' do small_array.push_front(&stacks[label], crate)
			label += 1
			j += 4
		}
	}


	// instructions will manipulate stacks
	// move 1 from 2 to 1
	for i := instructions_start; i <= instructions_end; i += 1 {
		temp: Stack = Stack{}
		move, from, to := move_from_to(lines[i])
		for n := 0; n < move; n += 1 {
			// small_array.push_front(&stacks[to], small_array.pop_front(&stacks[from]))
			small_array.push_front(&temp, small_array.pop_front(&stacks[from]))
		}
		for n := 0; n < move; n += 1 {
			small_array.push_front(&stacks[to], small_array.pop_front(&temp))
		}
	}

	fmt.println("Part 2: ")
	for k, v in stacks {
		if small_array.len(v) > 0 {
			fmt.println(k, v.data[0])
		} else {
			fmt.println(k, ' ')
		}
	}

}

/*
        [D]
        [N]
        [Z]
[M] [C] [P]
 1   2   3
*/
