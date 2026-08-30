# crownlet
 A dead simple video game library written in zig

## Example
``` zig
const std = @import("std");
const crown = @import("crownlet");

const player_png = @embedFile("player.png");
var player_texture: crown.graphics.Texture = undefined;

fn init() !void {
    player_texture = try crown.graphics.loadTexture(player_png);
}

fn update(delta_time: f32) !void {
    _ = delta_time;
}

fn draw() !void {
    try crown.window.clear(0, 0, 0, 255);
    try crown.graphics.drawTexture(player_texture, 100, 100);
    try crown.window.present();
}

pub fn main() !void {
    try crown.run(.{
        .init = &init,
        .update = &update,
        .draw = &draw,
    });
}
```
