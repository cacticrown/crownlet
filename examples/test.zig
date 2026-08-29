const std = @import("std");
const crown = @import("crownlet");

fn update(delta_time: f32) !void {
    std.debug.print("Update called with delta time: {d}\n", .{delta_time});
}

fn draw() void {
    crown.window.clear(0, 0, 0, 255);
    crown.window.present();
}

pub fn main() !void {
    try crown.run(.{
        .update = &update,
        .draw = &draw,
    });
}
