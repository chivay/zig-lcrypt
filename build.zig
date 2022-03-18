const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const mode = b.standardReleaseOptions();

    const simple_exe = b.addExecutable("simple", "examples/simple.zig");
    simple_exe.addPackagePath("lcrypt", "src/main.zig");
    simple_exe.single_threaded = true;
    simple_exe.setBuildMode(mode);
    simple_exe.strip = true;
    simple_exe.install();
}
