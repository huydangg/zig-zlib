const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "z",
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibC();
    lib.addCSourceFiles(.{ .files = srcs, .flags = &.{"-std=c89"} });

    lib.installHeader(.{ .path = "zlib/zlib.h" }, "zlib.h");
    lib.installHeader(.{ .path = "zlib/zconf.h" }, "zconf.h");

    b.installArtifact(lib);

    const tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
    });
    tests.linkLibrary(lib);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&tests.step);
}

const srcs = &.{
    "zlib/adler32.c",
    "zlib/compress.c",
    "zlib/crc32.c",
    "zlib/deflate.c",
    "zlib/gzclose.c",
    "zlib/gzlib.c",
    "zlib/gzread.c",
    "zlib/gzwrite.c",
    "zlib/inflate.c",
    "zlib/infback.c",
    "zlib/inftrees.c",
    "zlib/inffast.c",
    "zlib/trees.c",
    "zlib/uncompr.c",
    "zlib/zutil.c",
};
