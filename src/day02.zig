const std = @import("std");
const testing = std.testing;

const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day02.txt");

fn part1(input: []const u8) ![]const u8 {
    var iter = tokenizeAny(u8, input, "\r\n");

    const cube_count = std.ComptimeStringMap(i32, .{
        .{ "red", 12 },
        .{ "green", 13 },
        .{ "blue", 14 },
    });

    var sum: i32 = 0;
    var game_id: i32 = 0;
    while (iter.next()) |line| {
        // Starts at 1
        game_id += 1;

        var valid = true;

        const colon_id = indexOf(u8, line, ':').?;

        const game = line[colon_id + 1 ..];

        var cubes_iter = tokenizeAny(u8, game, ",;");

        while (cubes_iter.next()) |cube| {
            var cube_iter = tokenizeAny(u8, cube, " ");
            const value = try parseInt(u8, cube_iter.next().?, 10);
            const color = cube_iter.next().?;

            if (value > cube_count.get(color).?) {
                valid = false;
                break;
            }
        }

        if (valid) {
            sum += game_id;
        }
    }

    return std.fmt.allocPrint(gpa, "{}", .{sum});
}

fn part2(input: []const u8) ![]const u8 {
    var iter = tokenizeAny(u8, input, "\r\n");

    var sum: i32 = 0;
    while (iter.next()) |line| {
        const colon_id = indexOf(u8, line, ':').?;

        const game = line[colon_id + 1 ..];

        var rounds_iter = tokenizeAny(u8, game, ";");

        var min_red: i32 = 0;
        var min_green: i32 = 0;
        var min_blue: i32 = 0;

        while (rounds_iter.next()) |round| {
            var cubes_iter = tokenizeAny(u8, round, ",");

            while (cubes_iter.next()) |cube| {
                var cube_iter = tokenizeAny(u8, cube, " ");
                const value = try parseInt(u8, cube_iter.next().?, 10);
                const color = cube_iter.next().?;

                if (std.mem.eql(u8, "red", color)) {
                    if (value > min_red) {
                        min_red = value;
                    }
                } else if (std.mem.eql(u8, "green", color)) {
                    if (value > min_green) {
                        min_green = value;
                    }
                } else if (std.mem.eql(u8, "blue", color)) {
                    if (value > min_blue) {
                        min_blue = value;
                    }
                }
            }
        }

        sum += min_red * min_green * min_blue;
    }

    return std.fmt.allocPrint(gpa, "{}", .{sum});
}

test "part1" {
    const test_data =
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    ;
    const expected = "8";
    try testing.expectEqualSlices(u8, expected, try part1(test_data));
}

test "part2" {
    const test_data =
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    ;
    const expected = "2286";
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
