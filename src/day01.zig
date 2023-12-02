const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day01.txt");

pub fn main() !void {
    const test_str =
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
    ;
    _ = test_str;

    // const input = test_str;
    const input = data;

    var it = tokenizeAny(u8, input, "\r\n");

    var sum: i32 = 0;

    const with_letter_numbers = true;

    while (it.next()) |line| {
        const len = line.len;
        var first: i32 = -1;
        var first_pos: i32 = @intCast(len);

        var last: i32 = -1;
        var last_pos: i32 = -1;

        const nums = [_][]const u8{ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" };

        for (nums, 0..) |v, i| {
            var idx = indexOf(u8, line, v);
            if (idx) |index| {
                if (index < first_pos) {
                    first_pos = @intCast(index);
                    first = @intCast(i);
                }
            }

            idx = lastIndexOf(u8, line, v);
            if (idx) |index| {
                if (index > last_pos) {
                    last_pos = @intCast(index);
                    last = @intCast(i);
                }
            }
        }

        if (with_letter_numbers) {
            const num_letters = [_][]const u8{ "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };

            for (num_letters, 0..) |v, i| {
                var idx = indexOf(u8, line, v);
                if (idx) |index| {
                    if (index < first_pos) {
                        first_pos = @intCast(index);
                        first = @intCast(i);
                    }
                }

                idx = lastIndexOf(u8, line, v);
                if (idx) |index| {
                    if (index > last_pos) {
                        last_pos = @intCast(index);
                        last = @intCast(i);
                    }
                }
            }
        }

        const value = first * 10 + last;
        sum += value;
    }

    print("{}\n", .{sum});
}

// Useful stdlib functions
const tokenizeAny = std.mem.tokenizeAny;
const tokenizeSeq = std.mem.tokenizeSequence;
const tokenizeSca = std.mem.tokenizeScalar;
const splitAny = std.mem.splitAny;
const splitSeq = std.mem.splitSequence;
const splitSca = std.mem.splitScalar;
const indexOf = std.mem.indexOf;
const indexOfAny = std.mem.indexOfAny;
const lastIndexOf = std.mem.lastIndexOf;
const lastIndexOfAny = std.mem.lastIndexOfAny;
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
