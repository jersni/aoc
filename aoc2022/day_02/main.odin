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
	s1 := 0
	s2 := 0
	for line in lines {
		if len(line) < 3 do continue 
		r := Round{}
		r.elf = choice_part_1(line[0])
		r.me = choice_part_1(line[2])
		r.me2 = choice_part_2(line[0], line[2])

		s1 += score_part_1(r)
		s2 += score_part_2(r)
	}

	fmt.println("Part 1", s1)
	fmt.println("Part 2", s2)

	

}

Choice :: enum {
	rock, paper, scissor,
}

Round :: struct {
	elf: Choice,
	me: Choice,
	me2: Choice,
}

choice_part_1 :: proc(c: u8) -> Choice {
	if c == 'A' do return .rock
	if c == 'X' do return .rock
	if c == 'B' do return .paper
	if c == 'Y' do return .paper
	if c == 'C' do return .scissor
	if c == 'Z' do return .scissor
	panic( "Unexpected")
}

choice_part_2 :: proc (elf_choice, expected_outcome : u8) -> Choice {
	// part 2 X means lose, Y means draw, Z means win
	//  Rock defeats Scissors, Scissors defeats Paper, and Paper defeats Rock.
	c : Choice = .rock
	switch expected_outcome {
		case 'X':
			if elf_choice == 'A' do c = .scissor
			if elf_choice == 'B' do c = .rock
			if elf_choice == 'C' do c = .paper
		case 'Y':
			if elf_choice == 'A' do c = .rock
			if elf_choice == 'B' do c = .paper
			if elf_choice == 'C' do c = .scissor
		case 'Z':
			if elf_choice == 'A' do c = .paper
			if elf_choice == 'B' do c = .scissor
			if elf_choice == 'C' do c = .rock
	}

	return c
}

score_part_1 :: proc(r: Round) -> int {
	result := 0
	// score for selection
	if r.me == .rock do result += 1
	if r.me == .paper do result += 2
	if r.me == .scissor do result += 3

	// score for out come (if b loses, outcome score is 0)
	o := outcome(r.elf, r.me)
	switch o {
		case .win:
			result += 6
		case .lose:
			result += 0
		case .draw:
			result += 3
	}
	
	return result
}

score_part_2 :: proc(r: Round) -> int {
	result := 0
	// score for selection
	if r.me2 == .rock do result += 1
	if r.me2 == .paper do result += 2
	if r.me2 == .scissor do result += 3

	// score for out come (if b loses, outcome score is 0)
	o := outcome(r.elf, r.me2)
	switch o {
		case .win:
			result += 6
		case .lose:
			result += 0
		case .draw:
			result += 3
	}
	
	return result
}

Outcome :: enum {win, lose, draw}

outcome :: proc(elf, me : Choice) -> Outcome {
	if elf == me {
		return .draw
	} else {
		//  Rock defeats Scissors, Scissors defeats Paper, and Paper defeats Rock.
		switch me {
		case .rock:
			return elf == .scissor ? .win : .lose
		case .paper:
			return elf == .rock ? .win : .lose
		case .scissor:
			return elf == .paper ? .win : .lose
		}
	}
	panic("what?")
}




