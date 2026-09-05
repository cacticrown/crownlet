const std = @import("std");
const crown = @import("crownlet");

const player_png = @embedFile("player.png");
var player_texture: crown.graphics.Texture = undefined;

var player_x: f32 = 0;
const player_speed = 180;

fn init() !void {
    player_texture = try crown.graphics.loadTexture(player_png);
}

fn update(delta_time: f32) !void {
    if (crown.input.keyboard.keyPressed(.left)) {
        player_x -= player_speed * delta_time;
    }
    if (crown.input.keyboard.keyPressed(.right)) {
        player_x += player_speed * delta_time;
    }

    if (crown.input.keyboard.keyJustPressed(.f11)) {
        try crown.window.toggleFullscreen();
    }
}

fn draw() !void {
    try crown.graphics.clear(crown.graphics.Color.black);
    try crown.graphics.drawTexture(player_texture, player_x, 0);
    try crown.graphics.present();
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
        .height = 360,
        .width = 640,
        .window_title = "test",
    });
}
