const std = @import("std");
const testing = std.testing;

const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day12.txt");

fn part1(input: []const u8) ![]const u8 {
    _ = input;
    return "";
}

fn part2(input: []const u8) ![]const u8 {
    _ = input;
    return "";
}

// zig test src/day12.zig --test-filter part1
test "part1" {
    const test_data =
        \\TEST_DATA
    ;
    const expected = "TODO";
    try testing.expectEqualSlices(u8, expected, try part1(test_data));
}

// zig test src/day12.zig --test-filter part2
test "part2" {
    const test_data =
        \\TEST_DATA
    ;
    const expected = "TODO";
    try testing.expectEqualSlices(u8, expected, try part2(test_data));
}

pub fn main() !void {
    print("Part1: {s}\n", .{try part1(data)});
    print("Part2: {s}\n", .{try part2(data)});
}

// Useful stdlib functions
const tokenizeAny = std.mem.tokenizeAny;
const tokenizeSeq = std.mem.tokenizeSequence;
const tokenizeSca = std.mem.tokenizeScalar;
const splitAny = std.mem.splitAny;
const splitSeq = std.mem.splitSequence;
const splitSca = std.mem.splitScalar;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.block;
const asc = std.sort.asc;
const desc = std.sort.desc;

// Generated from template/template.zig.
// Run `zig build generate` to update.
// Only unmodified days will be updated.
