const std = @import("std");
const sdl = @import("sdl");
const crown = @import("crownlet");

const internalWindow = @import("internal/sdl_window.zig");

pub fn init(title: [:0]const u8, width: i32, height: i32) !void {
    internalWindow.current = try internalWindow.SdlWindow.init(title, width, height);
}

pub fn deinit() void {
    internalWindow.current.deinit();
}

pub fn clear(color: crown.graphics.Color) !void {
    try internalWindow.current.clear(color);
}

pub fn present() !void {
    try internalWindow.current.present();
}
