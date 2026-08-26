const std = @import("std");
const sdl = @import("sdl");

const InternalWindow = @import("internal/window.zig").Window;

pub fn run(updateFn: *const fn (delta_time: f32) anyerror!void, drawFn: *const fn () void) !void {
    const window = try InternalWindow.init("Crownlet", 800, 600);
    defer window.deinit();

    var event: sdl.SDL_Event = undefined;

    const performance_frequency: f32 = @floatFromInt(sdl.SDL_GetPerformanceFrequency());
    var last_time = sdl.SDL_GetPerformanceCounter();

    while (true) {
        const current_time = sdl.SDL_GetPerformanceCounter();
        const delta_time: f32 = @as(f32, @floatFromInt(current_time - last_time)) / performance_frequency;
        last_time = current_time;

        while (window.pollEvent(&event)) {
            if (event.type == sdl.SDL_EVENT_QUIT) {
                return;
            }
        }

        try updateFn(delta_time);

        window.clear(0, 0, 0, 255);
        drawFn();
        window.present();
    }
}
