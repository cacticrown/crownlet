# crownlet
 A dead simple video game library written in zig

## Example
``` zig
const std = @import("std");
const crown = @import("crownlet");

const png = @embedFile("player.png");
var texture: crown.graphics.Texture = undefined;

fn init() !void {
    texture = try crown.graphics.loadTexture(png);
}

fn update(delta_time: f32) !void {
    _ = delta_time;
}

fn draw() !void {
    try crown.graphics.clear(crown.graphics.Color.black);
    try crown.graphics.drawTexture(texture, 0, 0);
    try crown.graphics.present();
}

fn shutdown() !void {
    texture.deinit();
}

pub fn main() !void {
    try crown.run(.{
        .init = &init,
        .update = &update,
        .draw = &draw,
        .shutdown = &shutdown,
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
