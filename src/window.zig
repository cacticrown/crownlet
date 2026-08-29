const std = @import("std");
const sdl = @import("sdl");

const SDLWindow = @import("internal/sdl_window.zig").SdlWindow;

var sdlWindow: SDLWindow = undefined;

pub fn init(title: [:0]const u8, width: i32, height: i32) !void {
    sdlWindow = try SDLWindow.init(title, width, height);
}

pub fn deinit() void {
    sdlWindow.deinit();
}

pub fn clear(r: u8, g: u8, b: u8, a: u8) void {
    sdlWindow.clear(r, g, b, a);
}

pub fn present() void {
    sdlWindow.present();
}
