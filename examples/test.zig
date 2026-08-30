const std = @import("std");
const crown = @import("crownlet");

const player_png = @embedFile("player.png");
var player_texture: crown.graphics.Texture = undefined;

fn init() !void {
    player_texture = try crown.graphics.loadTexture(player_png);
}

fn update(delta_time: f32) !void {
    _ = delta_time;
    if (crown.input.keyboard.keyJustPressed(.space)) {
        std.debug.print("space!\n", .{});
    }
    if (crown.input.mouse.buttonJustPressed(.left)) {
        std.debug.print("left mouse button!\n", .{});
    }
    // std.debug.print("mouse x: {d}, y: {d}\n", .{ crown.input.mouse.x, crown.input.mouse.y });
}

fn draw() !void {
    try crown.window.clear(crown.graphics.Color.init(0, 0, 0, 255));
    try crown.graphics.drawTexture(player_texture, 0, 0);
    try crown.window.present();
}

fn shutdown() !void {
    player_texture.deinit();
}

pub fn main() !void {
    try crown.run(.{
        .init = &init,
        .update = &update,
        .draw = &draw,
        .shutdown = &shutdown,
        .height = 320,
        .width = 320,
        .window_title = "test",
    });
}
