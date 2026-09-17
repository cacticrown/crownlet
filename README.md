# crownlet
 A dead simple video 2D game library written in zig

[![License](https://img.shields.io/github/license/cacticrown/crownlet)](LICENSE)
[![Zig Version](https://img.shields.io/badge/zig-0.16.0-orange.svg)](https://ziglang.org/)
[![Documentation](https://img.shields.io/badge/docs-online-blue.svg)](https://crownlet.github.io/)

## Example
``` zig
const crown = @import("crownlet");

const Game = struct {};

fn draw(game: *Game) !void {
    _ = game;
    try crown.graphics.begin(.{});
    try crown.graphics.clear(crown.graphics.Color.black);
    try crown.graphics.end();
}

pub fn main() !void {
    var game = Game{};

    try crown.run(&game, .{
        .draw = &draw,
        .window_title = "example",
    });
}
```

## Getting started

Fetch and save crownlet to your `build.zig.zon` by running this command:

```bash
zig fetch --save git+https://github.com/cacticrown/crownlet
```

Then in your `build.zig`, add the dependency and import the `crownlet` module into whatever module/executable needs it:

```zig
const crownlet_dep = b.dependency("crownlet", .{
    .target = target,
    .optimize = optimize,
});

exe.root_module.addImport("crownlet", crownlet_dep.module("crownlet"));
```

See this [example repository](https://github.com/cacticrown/crownlet-example) for more details.
