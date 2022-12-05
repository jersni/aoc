package main
import "core:fmt"
import "core:strings"
import h "../helpers"


main :: proc() {
	data := h.read_file("input.txt")
	defer delete(data)

	lines := strings.split_lines(string(data))
	defer delete(lines)

	part1(lines)
	part2(lines)

}

priorities := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

part1 :: proc(lines: []string) {
	result := 0
	for line in lines {
		if len(line) == 0 do break
		a := line[:len(line) / 2]
		b := line[len(line) / 2:]
		search: for x in a {
			if strings.contains_rune(b, x) >= 0 {
				result += priority(x)
				break search
			}
		}
	}
	fmt.println("Part 1: ", result)
}

part2 :: proc(lines: []string) {
	group := 0
	result := 0
	for group < len(lines) / 3 {
		b := badge_priority(lines[3 * group], lines[3 * group + 1], lines[3 * group + 2])
		result += b
		group += 1
	}
	fmt.println("Part 2: ", result)
}

badge_priority :: proc(a, b, c: string) -> int {
	for x in a {
		if strings.contains_rune(b, x) >= 0 && strings.contains_rune(c, x) >= 0 {
			return priority(x)
		}
	}
	panic(fmt.tprintf("expected to find a badge priority %s", a))
}

priority :: proc(value: rune) -> int {
	for p, i in priorities {
		if p == value do return i + 1
	}
	panic(fmt.tprintf("expected to find something for %s", value))
}
