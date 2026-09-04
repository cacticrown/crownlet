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
