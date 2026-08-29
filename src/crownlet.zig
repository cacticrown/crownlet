const std = @import("std");
const sdl = @import("sdl");

pub const window = @import("window.zig");

pub const Config = struct {
    update: ?*const fn (delta_time: f32) anyerror!void = null,
    draw: ?*const fn () void = null,
};

pub fn run(config: Config) !void {
    try window.init("Crownlet", 800, 600);
    defer window.deinit();

    var event: sdl.SDL_Event = undefined;

    const performance_frequency: f32 = @floatFromInt(sdl.SDL_GetPerformanceFrequency());
    var last_time = sdl.SDL_GetPerformanceCounter();

    while (true) {
        const current_time = sdl.SDL_GetPerformanceCounter();
        const delta_time: f32 = @as(f32, @floatFromInt(current_time - last_time)) / performance_frequency;
        last_time = current_time;

        while (sdl.SDL_PollEvent(&event)) {
            if (event.type == sdl.SDL_EVENT_QUIT) {
                return;
            }
        }

        if (config.update) |update| {
            try update(delta_time);
        }

        if (config.draw) |draw| {
            draw();
        }
    }
}
