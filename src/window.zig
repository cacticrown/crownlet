const std = @import("std");
const sdl = @import("sdl");

const internalWindow = @import("internal/sdl_window.zig");

pub fn init(title: [:0]const u8, width: i32, height: i32) !void {
    internalWindow.current = try internalWindow.SdlWindow.init(title, width, height);
}

pub fn deinit() void {
    internalWindow.current.deinit();
}

pub fn clear(r: u8, g: u8, b: u8, a: u8) void {
    internalWindow.current.clear(r, g, b, a);
}

pub fn present() void {
    internalWindow.current.present();
}
