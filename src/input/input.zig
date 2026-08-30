const std = @import("std");
const sdl = @import("sdl");

pub const keyboard = @import("keyboard.zig");
pub const mouse = @import("mouse.zig");

pub fn update() void {
    keyboard.update();
    mouse.update();
}
