const std = @import("std");
const sdl = @import("sdl");

pub var current: SdlWindow = undefined;

pub const SdlWindow = struct {
    window: *sdl.SDL_Window,
    renderer: *sdl.SDL_Renderer,

    pub fn init(title: [*:0]const u8, width: i32, height: i32) !SdlWindow {
        if (!sdl.SDL_Init(sdl.SDL_INIT_VIDEO)) {
            std.debug.print("SDL Init Error: {s}\n", .{sdl.SDL_GetError()});
            return error.SDLInitFailed;
        }

        const window = sdl.SDL_CreateWindow(title, width, height, 0) orelse {
            sdl.SDL_Quit();
            std.debug.print("Window Error: {s}\n", .{sdl.SDL_GetError()});
            return error.WindowCreationFailed;
        };

        const renderer = sdl.SDL_CreateRenderer(window, null) orelse {
            sdl.SDL_DestroyWindow(window);
            sdl.SDL_Quit();
            std.debug.print("Renderer Error: {s}\n", .{sdl.SDL_GetError()});
            return error.RendererCreationFailed;
        };

        return SdlWindow{
            .window = window,
            .renderer = renderer,
        };
    }

    pub fn deinit(self: *const SdlWindow) void {
        sdl.SDL_DestroyRenderer(self.renderer);
        sdl.SDL_DestroyWindow(self.window);
        sdl.SDL_Quit();
    }

    pub fn clear(self: *const SdlWindow, r: u8, g: u8, b: u8, a: u8) void {
        _ = sdl.SDL_SetRenderDrawColor(self.renderer, r, g, b, a);
        _ = sdl.SDL_RenderClear(self.renderer);
    }

    pub fn present(self: *const SdlWindow) void {
        _ = sdl.SDL_RenderPresent(self.renderer);
    }
};
