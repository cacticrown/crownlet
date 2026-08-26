const std = @import("std");
const crown = @import("crownlet");

fn update(delta_time: f32) !void {
    std.debug.print("Update called with delta time: {d}\n", .{delta_time});
}

fn draw() void {
    std.debug.print("Draw called\n", .{});
}

pub fn main() !void {
    try crown.run(update, draw);
}
