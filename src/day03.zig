const std = @import("std");
const testing = std.testing;

const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;
const abs = util.abs;

const data = @embedFile("data/day03.txt");

const Num = struct {
    value: i32,
    x: i32,
    y: i32,
    w: i32,
};

const Sym = struct {
    x: i32,
    y: i32,
};

fn is_num(in: u8) bool {
    return in >= '0' and in <= '9';
}

fn touches(num: Num, sym: Sym) bool {
    const x_ok = sym.x >= num.x - 1 and sym.x <= num.x + num.w + 1;
    const y_ok = sym.y >= num.y - 1 and sym.y <= num.y + 1;

    return x_ok and y_ok;
}

fn part1(input: []const u8) ![]const u8 {
    var iter = tokenizeAny(u8, input, "\r\n");

    var nums = List(Num).init(gpa);
    defer nums.deinit();

    var syms = List(Sym).init(gpa);
    defer syms.deinit();

    var y: i32 = 0;

    while (iter.next()) |line| {
        var i: usize = 0;
        while (i < line.len) : (i += 1) {
            const c = line[i];

            if (c == '.') continue;

            if (is_num(c)) {
                var n: i32 = 0;
                const start = i;

                while (i < line.len and is_num(line[i])) {
                    const v: i32 = @intCast(line[i] - '0');
                    n = n * 10 + v;
                    i += 1;
                }
                i -= 1;

                const num = Num{
                    .value = n,
                    .x = @intCast(start),
                    .y = y,
                    .w = @intCast(i - start),
                };
                try nums.append(num);
            } else {
                const sym = Sym{ .x = @intCast(i), .y = y };
                try syms.append(sym);
            }
        }

        y += 1;
    }

    var sum: i32 = 0;

    for (nums.items) |num| {
        var touches_one = false;
        for (syms.items) |sym| {
            if (touches(num, sym)) {
                touches_one = true;
                break;
            }
        }

        if (touches_one) {
            sum += num.value;
        }
    }

    return std.fmt.allocPrint(gpa, "{d}", .{sum});
}

fn part2(input: []const u8) ![]const u8 {
    var iter = tokenizeAny(u8, input, "\r\n");

    var nums = List(Num).init(gpa);
    defer nums.deinit();

    var syms = List(Sym).init(gpa);
    defer syms.deinit();

    var y: i32 = 0;

    while (iter.next()) |line| {
        var i: usize = 0;
        while (i < line.len) : (i += 1) {
            const c = line[i];

            if (is_num(c)) {
                var n: i32 = 0;
                const start = i;

                while (i < line.len and is_num(line[i])) {
                    const v: i32 = @intCast(line[i] - '0');
                    n = n * 10 + v;
                    i += 1;
                }
                i -= 1;

                const num = Num{
                    .value = n,
                    .x = @intCast(start),
                    .y = y,
                    .w = @intCast(i - start),
                };
                try nums.append(num);
            } else if (c == '*') {
                const sym = Sym{ .x = @intCast(i), .y = y };
                try syms.append(sym);
            } else {
                continue;
            }
        }

        y += 1;
    }

    print("{}\n", .{syms.items.len});
    var sum: i32 = 0;

    var touching = List(Num).init(gpa);
    defer touching.deinit();

    for (syms.items) |sym| {
        touching.clearRetainingCapacity();

        for (nums.items) |num| {
            if (touches(num, sym)) {
                try touching.append(num);
            }
        }

        if (touching.items.len == 2) {
            sum += touching.items[0].value * touching.items[1].value;
        }
    }

    return std.fmt.allocPrint(gpa, "{d}", .{sum});
}

// zig test src/day03.zig --test-filter part1
test "part1" {
    const test_data =
        \\467..114..
        \\...*......
        \\..35..633.
        \\......#...
        \\617*......
        \\.....+.58.
        \\..592.....
        \\......755.
        \\...$.*....
        \\.664.598..
    ;
    const expected = "4361";
    try testing.expectEqualSlices(u8, expected, try part1(test_data));
}

// zig test src/day03.zig --test-filter part2
test "part2" {
    const test_data =
        \\467..114..
        \\...*......
        \\..35..633.
        \\......#...
        \\617*......
        \\.....+.58.
        \\..592.....
        \\......755.
        \\...$.*....
        \\.664.598..
    ;
    const expected = "467835";
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
