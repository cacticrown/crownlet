const std = @import("std");
const sdl = @import("sdl");

pub const graphics = @import("graphics/graphics.zig");
pub const window = @import("window.zig");
pub const input = @import("input/input.zig");

pub fn Config(comptime Context: type) type {
    return struct {
        init: ?*const fn (ctx: *Context) anyerror!void = null,
        update: ?*const fn (ctx: *Context, delta_time: f32) anyerror!void = null,
        draw: ?*const fn (ctx: *Context) anyerror!void = null,
        shutdown: ?*const fn (ctx: *Context) anyerror!void = null,
        width: i32 = 640,
        height: i32 = 360,
        fullscreen: bool = false,
        window_title: [:0]const u8 = "crownlet",
        target_fps: u32 = 60, // 0 = uncapped
        vsync: bool = true,
    };
}

pub fn run(context: anytype, config: Config(@TypeOf(context.*))) !void {
    try window.init(config.window_title, config.width, config.height);
    defer window.deinit();

    try graphics.init();
    defer graphics.deinit();

    try graphics.setVSync(config.vsync);
    try window.setFullscreen(config.fullscreen);

    var event: sdl.SDL_Event = undefined;

    const performance_frequency: f32 = @floatFromInt(sdl.SDL_GetPerformanceFrequency());
    var last_time = sdl.SDL_GetPerformanceCounter();

    if (config.init) |init| {
        try init(context);
    }

    while (true) {
        const frame_start = sdl.SDL_GetPerformanceCounter();
        const delta_time: f32 = @as(f32, @floatFromInt(frame_start - last_time)) / performance_frequency;
        last_time = frame_start;

        while (sdl.SDL_PollEvent(&event)) {
            if (event.type == sdl.SDL_EVENT_QUIT) {
                if (config.shutdown) |shutdown| {
                    try shutdown(context);
                }
                return;
            }
        }

        input.update();

        if (config.update) |update| {
            try update(context, delta_time);
        }

        if (config.draw) |draw| {
            try draw(context);
        }

        if (config.target_fps > 0 and !config.vsync) {
            const target_frame_time = performance_frequency / @as(f32, @floatFromInt(config.target_fps));
            const frame_end = sdl.SDL_GetPerformanceCounter();
            const elapsed_ticks = @as(f32, @floatFromInt(frame_end - frame_start));

            if (elapsed_ticks < target_frame_time) {
                const remaining_ticks = target_frame_time - elapsed_ticks;
                const delay_ms: u32 = @intFromFloat((remaining_ticks / performance_frequency) * 1000.0);
                if (delay_ms > 0) {
                    sdl.SDL_Delay(delay_ms);
                }
            }
        }
    }
}
