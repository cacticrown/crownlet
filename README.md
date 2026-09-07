# crownlet
 A dead simple video game library written in zig

## Example
``` zig
const crown = @import("crownlet");

const Game = struct {};

fn init(game: *Game) !void {
    _ = game;
}

fn update(game: *Game, delta_time: f32) !void {
    _ = game;
    _ = delta_time;
}

fn draw(game: *Game) !void {
    _ = game;
    try crown.graphics.clear(crown.graphics.Color.black);
    try crown.graphics.present();
}

fn shutdown(game: *Game) !void {
    _ = game;
}

pub fn main() !void {
    var game = Game{};

    try crown.run(&game, .{
        .init = &init,
        .update = &update,
        .draw = &draw,
        .shutdown = &shutdown,
        .window_title = "example",
    });
}
```

## Getting started

Fetch and save crownlet to your `build.zig.zon` by running this command:

```bash
zig fetch --save=crownlet git+https://github.com/cacticrown/crownlet.git
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
