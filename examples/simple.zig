const std = @import("std");
const lcrypt = @import("lcrypt");

pub fn main() void {
    std.debug.print("{s}\n", .{"zig-lcrypt"});
    std.debug.print("{s}\n", .{lcrypt.string("Hello from a secret string!")});
    std.debug.print("{x}\n", .{lcrypt.int(u64, 0x4141414141414141)});
}
