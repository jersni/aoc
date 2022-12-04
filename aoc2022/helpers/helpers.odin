package helpers

import "core:os"

read_file :: proc(filepath: string, allocator := context.allocator) -> []byte {
	context.allocator = allocator
	data, ok := os.read_entire_file(filepath)
	if !ok {
		panic("could not read file")
	}

	return data
}