const std = @import("std");
const crown = @import("crownlet");

const player_png = @embedFile("player.png");
const player_speed = 180;

const Game = struct {
    player_texture: crown.graphics.Texture = undefined,
    player_position: crown.math.Vector2 = .init(0, 0),
    canvas: crown.graphics.RenderTarget = undefined,
};

fn init(game: *Game) !void {
    game.player_texture = try crown.graphics.loadTextureFromBytes(player_png);
    // game.player_texture = try crown.graphics.loadTextureFromFile("/home/cacti/dev/crownlet/examples/player.png");

    const size = try game.player_texture.getSize();
    std.debug.print("texture width: {} height: {}\n", .{ size.width, size.height });

    game.canvas = try crown.graphics.createRenderTarget(320, 180);
}

fn update(game: *Game, delta_time: f32) !void {
    if (crown.input.keyboard.keyPressed(.left)) {
        game.player_position.x -= player_speed * delta_time;
    }
    if (crown.input.keyboard.keyPressed(.right)) {
        game.player_position.x += player_speed * delta_time;
    }

    if (crown.input.keyboard.keyJustPressed(.f11)) {
        try crown.window.toggleFullscreen();
    }
}

fn draw(game: *Game) !void {
    try crown.graphics.setRenderTarget(game.canvas);

    try crown.graphics.clear(crown.graphics.Color.black);
    try crown.graphics.drawTexture(game.player_texture, game.player_position);

    try crown.graphics.setRenderTarget(null);

    try crown.graphics.clear(crown.graphics.Color.black);
    try crown.graphics.drawRenderTarget(game.canvas, crown.math.Vector2.init(0, 0));

    try crown.graphics.present();
}

fn shutdown(game: *Game) !void {
    game.player_texture.deinit();
    game.canvas.deinit();
}

pub fn main() !void {
    var game = Game{};

    try crown.run(&game, .{
        .init = &init,
        .update = &update,
        .draw = &draw,
        .shutdown = &shutdown,
        .height = 360,
        .width = 640,
        .window_title = "test",
        .resizeable = true,
    });
}
