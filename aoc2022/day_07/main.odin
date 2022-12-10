package main
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:container/small_array"
import h "../helpers"

main :: proc() {
	when 1 == 1 do file := "sample_input.txt"
	when 1 == 2 do file := "input.txt"
	data := h.read_file(file)
	defer delete(data)

	lines := strings.split_lines(string(data))
	defer delete(lines)

	part1(lines)
}

part1 :: proc(data: []string) {
	lines := make([dynamic]Line, 0, 2000)
	for d, i in data {
		if index := strings.index(d, "$"); index == 0 {
			append(&lines, Line{kind = "command", value = d[(index + len("$ ")):]})
		} else if index := strings.index(d, "dir"); index == 0 {
			append(&lines, Line{kind = "dir", value = d[(index + len("dir ")):]})
		} else {
			append(&lines, Line{kind = "file", value = d})
		}
	}

	root: Directory = init_directory("/", nil)
	current_dir: ^Directory = &root

	for l in lines {
		switch l.kind {
		case "command":
			if index := strings.index(l.value, "cd "); index == 0 {
				if dir_name := l.value[index + 3:]; dir_name == ".." {
					if current_dir.parent != nil {
						current_dir = current_dir.parent
					}
				} else {
					current_dir = change_dir(current_dir, dir_name)
				}
			} else if index := strings.index(l.value, "ls"); index == 0 {
				// ignoring ls ...
			}
		case "dir":
			make_dir(current_dir, l.value)
		case "file":
			f := strings.split(l.value, " ")
			make_file(current_dir, f[1], strconv.atoi(f[0]))
		}
	}

	print_dir(&root)

}


Line :: struct {
	kind:  string,
	value: string,
}

File :: struct {
	name: string,
	size: int,
}

Directory :: struct {
	name:    string,
	subdirs: [dynamic]Directory,
	files:   [dynamic]File,
	parent:  ^Directory,
}

init_directory :: proc(name: string, parent: ^Directory) -> Directory {
	d := Directory{}
	d.name = name
	d.files = make([dynamic]File)
	d.subdirs = make([dynamic]Directory)
	d.parent = parent
	return d
}

change_dir :: proc(current: ^Directory, target: string) -> ^Directory {
	for d, i in current.subdirs {
		if d.name == target do return &current.subdirs[i]
	}
	return current
}

make_dir :: proc(current: ^Directory, name: string) -> Directory {
	dir := init_directory(name, current)
	append(&current.subdirs, dir)
	return dir
}

make_file :: proc(current: ^Directory, name: string, size: int) {
	append(&current.files, File{name = name, size = size})
}

print_dir :: proc(dir: ^Directory, indent := 0) {
	if indent == 0 {
		print_spaces(4 * indent)
		fmt.println(dir.name)
	}
	for s, i in dir.subdirs {
		print_spaces(4 * indent)
		fmt.println(" - ", s.name)
		print_dir(&dir.subdirs[i], indent + 1)
	}
	for f in dir.files {
		print_spaces(4 * 2 * indent)
		fmt.println(" - ", f.name, f.size)
	}
}

print_spaces :: proc(n: int) {
	for i in 0 ..< n {
		fmt.print(" ")
	}
}
