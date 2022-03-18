# zig-lcrypt

This is a PoC implementation of literal encryption for Zig programming language.

Example usage:

examples/simple.zig:

```zig
const std = @import("std");
const lcrypt = @import("lcrypt");

pub fn main() void {
    std.debug.print("{s}\n", .{"zig-lcrypt"});
    std.debug.print("{s}\n", .{lcrypt.string("Hello from a secret string!")});
    std.debug.print("{x}\n", .{lcrypt.int(u64, 0x4141414141414141)});
}
```

Build with all optimizations:

```
$ zig build -Drelease-fast
```

```
$ zig-out/bin/simple
zig-lcrypt
Hello from a secret string!
4141414141414141
```

```
$ strings zig-out/bin/simple | grep -e zig-lcrypt -e AAAA -e Hello
zig-lcrypt
```
