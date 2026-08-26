const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const translate_c = b.addTranslateC(.{
        .root_source_file = b.path("src/c.h"),
        .target = target,
        .optimize = optimize,
    });
    const sdl_mod = translate_c.createModule();

    const crownlet_mod = b.addModule("crownlet", .{
        .root_source_file = b.path("src/crownlet.zig"),
        .target = target,
        .optimize = optimize,
    });

    crownlet_mod.addImport("sdl", sdl_mod);
    crownlet_mod.linkSystemLibrary("SDL3", .{});

    const lib = b.addLibrary(.{
        .name = "crownlet",
        .linkage = .static,
        .root_module = crownlet_mod,
    });

    b.installArtifact(lib);

    // examples

    const examples = &[_]struct {
        name: []const u8,
        path: []const u8,
    }{
        .{ .name = "test", .path = "examples/test.zig" },
    };

    for (examples) |example| {
        const exe = b.addExecutable(.{
            .name = example.name,
            .root_module = b.createModule(.{
                .root_source_file = b.path(example.path),
                .target = target,
                .optimize = optimize,
                .imports = &.{
                    .{
                        .name = "crownlet",
                        .module = crownlet_mod,
                    },
                },
            }),
        });

        exe.root_module.addImport("crownlet", crownlet_mod);

        const run_cmd = b.addRunArtifact(exe);
        run_cmd.step.dependOn(b.getInstallStep());

        const run_step = b.step(
            b.fmt("run-{s}", .{example.name}),
            b.fmt("Run the {s} example", .{example.name}),
        );
        run_step.dependOn(&run_cmd.step);
    }
}
