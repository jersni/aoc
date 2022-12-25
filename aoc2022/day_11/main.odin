package main
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"
import h "../helpers"

SAMPLE :: true
when SAMPLE {
	file := "sample_input.txt"

}
when !SAMPLE {
	file := "input.txt"

}
ROUNDS :: 20
main :: proc() {
	data := h.read_file(file)
	defer delete(data)

	lines := strings.split_lines(string(data))
	defer delete(lines)

	part1(lines)

}

part1 :: proc(lines: []string) {
	monkeys: [10]Monkey
	init_monkeys(lines, monkeys[:])
}

Operation :: enum {
	add_n,
	add_old,
	mult_n,
	mult_old,
}

Monkey :: struct {
	alive:        bool,
	id:           int,
	items:        [dynamic]int,
	op:           Operation,
	n:            int,
	divisible_by: int,
	true_target:  int,
	false_target: int,
	inspections:  int,
}


init_monkeys :: proc(data: []string, monkeys: []Monkey) {
	monkey: int
	for line in data {
		if i := strings.index(line, "Monkey "); i >= 0 {
			monkey = read_id(line[len("Monkey "):])
			monkeys[monkey].id = monkey
			monkeys[monkey].alive = true
		} else if i := strings.index(line, "Starting items: "); i >= 0 {
			monkeys[monkey].items = make([dynamic]int)
			read_items(line[i + len("Starting items: "):], &monkeys[monkey].items)
		} else if i := strings.index(line, "Operation: new = "); i >= 0 {
			op, n := read_operation(line[i + len("Operation: new = "):])
			monkeys[monkey].op = op
			monkeys[monkey].n = n
		} else if i := strings.index(line, "Test: divisible by "); i >= 0 {
			monkeys[monkey].divisible_by = read_div_by(line, i)
		} else if i := strings.index(line, "If true: throw to monkey "); i >= 0 {
			monkeys[monkey].true_target = read_target(line, i, "If true: throw to monkey ")
		} else if i := strings.index(line, "If false: throw to monkey "); i >= 0 {
			monkeys[monkey].false_target = read_target(line, i, "If false: throw to monkey ")
		}
	}
	for round := 0; round < ROUNDS; round += 1 {
		for m, i in monkeys {
			if !m.alive do continue
			if len(m.items) > 0 {
				for item in m.items {
					monkeys[i].inspections += 1
					wl := item
					switch m.op {
					case Operation.mult_n:
						wl = wl * m.n
					case Operation.mult_old:
						wl = wl * wl
					case Operation.add_n:
						wl = wl + m.n
					case Operation.add_old:
						wl = wl + wl
					}
					wl = wl / 3
					if wl % m.divisible_by == 0 {
						append(&monkeys[m.true_target].items, wl)
					} else {

						append(&monkeys[m.false_target].items, wl)
					}

				}
				clear(&monkeys[i].items)
			}
		}
	}

	slice.sort_by(monkeys[:], compare_by_inspections)
    for m in monkeys {
        if !m.alive do continue
        fmt.println(m.id, m.inspections)
    }
    fmt.println("Part 1: ", monkeys[0].inspections * monkeys[1].inspections)

}

compare_by_inspections :: proc(a, b: Monkey) -> bool {
    return a.inspections > b.inspections
}

read_id :: proc(line: string) -> int {
	data := strings.split(line, ":")
	defer delete(data)
	return strconv.atoi(data[0])
}

read_items :: proc(line: string, items: ^[dynamic]int) {
	data := strings.split(line, ", ")
	defer delete(data)
	for i in data {
		append(items, strconv.atoi(i))
	}
}


read_operation :: proc(line: string) -> (op: Operation, n: int) {
	if strings.index(line, "+") >= 0 {
		parts := strings.split(line, "+ ")
		defer delete(parts)
		if parts[1] == "old" {
			op = Operation.add_old
			n = 0
		} else {
			op = Operation.add_n
			n = strconv.atoi(parts[1])
		}
	} else if strings.index(line, "*") >= 0 {
		parts := strings.split(line, " * ")
		defer delete(parts)
		if parts[1] == "old" {
			op = Operation.mult_old
			n = 0
		} else {
			op = Operation.mult_n
			n = strconv.atoi(parts[1])
		}

	} else {
		panic(fmt.tprintf("unknown op: %v", line))
	}
	return
}

read_div_by :: proc(line: string, from: int) -> int {
	return strconv.atoi(line[from + len("Test: divisible by "):])
}

read_target :: proc(line: string, from: int, pattern: string) -> int {
	return strconv.atoi(line[from + len(pattern):])
}
