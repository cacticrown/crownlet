const std = @import("std");
const sdl = @import("sdl");
const crown = @import("crownlet");

const state = @import("internal/state.zig");

pub fn init(title: [:0]const u8, width: i32, height: i32) !void {
    state.window = sdl.SDL_CreateWindow(title, width, height, 0) orelse {
        std.debug.print("Window Creation failed: {s}\n", .{sdl.SDL_GetError()});
        return error.WindowCreationFailed;
    };
}

pub fn deinit() void {
    sdl.SDL_DestroyWindow(state.window);
}

pub fn setFullscreen(value: bool) !void {
    if (!sdl.SDL_SetWindowFullscreen(state.window, value)) {
        std.debug.print("Setting Fullscreen failed: {s}\n", .{sdl.SDL_GetError()});
        return error.SettingFullscreenFailed;
    }
}

pub fn isFullscreen() bool {
    const flags = sdl.SDL_GetWindowFlags(state.window);

    return (flags & sdl.SDL_WINDOW_FULLSCREEN) != 0;
}

pub fn toggleFullscreen() !void {
    const fullscreen = isFullscreen();
    try setFullscreen(!fullscreen);
}
