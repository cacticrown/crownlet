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
