const std = @import("std");
const crown = @import("crownlet");

const player_png = @embedFile("player.png");
var player_texture: crown.graphics.Texture = undefined;

fn init() !void {
    player_texture = try crown.graphics.loadTexture(player_png);
}

fn update(delta_time: f32) !void {
    std.debug.print("Update called with delta time: {d}\n", .{delta_time});
}

fn draw() !void {
    crown.window.clear(0, 0, 0, 255);
    try crown.graphics.drawTexture(player_texture, 100, 100);
    crown.window.present();
}

pub fn main() !void {
    try crown.run(.{
        .init = &init,
        .update = &update,
        .draw = &draw,
    });
}
