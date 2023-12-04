const std = @import("std");
const testing = std.testing;

const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("data/day04.txt");

fn part1(input: []const u8) !i32 {
    var iter = tokenizeAny(u8, input, "\r\n");

    var winning_nums = List(i32).init(gpa);
    defer winning_nums.deinit();

    var sum: i32 = 0;

    while (iter.next()) |line| {
        const colon_id = indexOf(u8, line, ':').?;

        const card = line[colon_id + 1 ..];

        const pipe_id = indexOf(u8, card, '|').?;

        const winning_str = card[0..pipe_id];
        const results_str = card[pipe_id + 1 ..];

        winning_nums.clearRetainingCapacity();

        var winning_iter = tokenizeAny(u8, winning_str, " ");
        while (winning_iter.next()) |num_str| {
            const num = try parseInt(i32, num_str, 10);
            try winning_nums.append(num);
        }

        var points: i32 = 0;

        var results_iter = tokenizeAny(u8, results_str, " ");
        while (results_iter.next()) |num_str| {
            const num = try parseInt(i32, num_str, 10);

            if (util.contains(i32, &winning_nums, num)) {
                points = if (points == 0) 1 else points * 2;
            }
        }

        sum += points;
    }

    return sum;
}

const Card = struct {
    winning: List(i32),
    results: List(i32),

    pub fn init() Card {
        const card = Card{
            .winning = List(i32).init(gpa),
            .results = List(i32).init(gpa),
        };
        return card;
    }

    pub fn wins(card: Card) i32 {
        var r: i32 = 0;
        for (card.results.items) |n| {
            for (card.winning.items) |m| {
                if (n == m) {
                    r += 1;
                    break;
                }
            }
        }

        return r;
    }
};

fn part2(input: []const u8) !i32 {
    var iter = tokenizeAny(u8, input, "\r\n");

    var cards = List(struct { Card, i32 }).init(gpa);

    while (iter.next()) |line| {
        const colon_id = indexOf(u8, line, ':').?;

        const card_str = line[colon_id + 1 ..];

        const pipe_id = indexOf(u8, card_str, '|').?;

        var card = Card.init();

        const winning_str = card_str[0..pipe_id];
        const results_str = card_str[pipe_id + 1 ..];

        var winning_iter = tokenizeAny(u8, winning_str, " ");
        while (winning_iter.next()) |num_str| {
            const num = try parseInt(i32, num_str, 10);
            try card.winning.append(num);
        }

        var results_iter = tokenizeAny(u8, results_str, " ");
        while (results_iter.next()) |num_str| {
            const num = try parseInt(i32, num_str, 10);
            try card.results.append(num);
        }

        try cards.append(.{ card, 1 });
    }

    const nb_cards = cards.items.len;

    for (cards.items, 0..) |card, i| {
        const wins = card.@"0".wins();

        for (util.range(@intCast(wins)), 0..) |_, j| {
            const idx = i + 1 + j;
            if (idx < nb_cards) {
                for (util.range(@intCast(card.@"1"))) |_| {
                    cards.items[idx].@"1" += 1;
                }
            }
        }
    }

    var sum: i32 = 0;
    for (cards.items) |card| {
        sum += card.@"1";
    }

    return sum;
}

// zig test src/day04.zig --test-filter part1
test "part1" {
    const test_data =
        \\Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
        \\Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
        \\Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
        \\Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
        \\Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
        \\Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    ;
    const expected: i32 = 13;
    try testing.expectEqual(expected, try part1(test_data));
}

// zig test src/day04.zig --test-filter part2
test "part2" {
    const test_data =
        \\Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
        \\Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
        \\Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
        \\Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
        \\Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
        \\Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    ;
    const expected: i32 = 30;
    try testing.expectEqual(expected, try part2(test_data));
}

pub fn main() !void {
    print("Part1: {}\n", .{try part1(data)});
    print("Part2: {}\n", .{try part2(data)});
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
