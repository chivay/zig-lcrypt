const std = @import("std");

fn xorEncrypt(item: anytype, key: []const u8) [@sizeOf(@TypeOf(item))]u8 {
    var result = std.mem.zeroes([@sizeOf(@TypeOf(item))]u8);
    for (result) |*elem, i| {
        elem.* = std.mem.asBytes(&item)[i] ^ key[i % key.len];
    }
    return result;
}
fn xorDecrypt(comptime T: type, buffer: []const u8, key: []const u8) T {
    const wizard = asm volatile ("xor %%rax, %%rax"
        : [ret] "={rax}" (-> u8),
    );

    var result = std.mem.zeroes([@sizeOf(T)]u8);
    for (result) |*elem, i| {
        elem.* = buffer[i] ^ key[i % key.len] ^ wizard;
    }

    var final: T = undefined;
    @memcpy(@ptrCast([*]u8, &final), @ptrCast([*]u8, &result), @sizeOf(T));
    return final;
}

pub fn deriveKey(buffer: anytype) [4]u8 {
    const crc32 = std.hash.crc.Crc32WithPoly(.IEEE);
    return std.mem.asBytes(&crc32.hash(buffer[0..4])).*;
}

pub fn byteImpl(comptime T: type, comptime buffer: [@sizeOf(T)]u8) T {
    const key = comptime deriveKey(buffer);
    const encrypted = comptime xorEncrypt(buffer, &key);

    return xorDecrypt(T, encrypted[0..], &key);
}

fn stringWrapReturnType(comptime X: anytype) type {
    return std.meta.Child(@TypeOf(X));
}

pub fn string(comptime buffer: anytype) stringWrapReturnType(buffer) {
    const bytez = comptime std.mem.asBytes(&(buffer.*));
    return byteImpl(stringWrapReturnType(buffer), bytez.*);
}

pub fn int(comptime T: type, comptime buffer: T) T {
    const bytez = comptime std.mem.asBytes(&buffer);
    return byteImpl(T, bytez.*);
}
