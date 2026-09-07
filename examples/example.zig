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
