const std = @import("std");
const sdl = @import("sdl");

pub const Texture = struct {
    texture: *sdl.SDL_Texture,

    pub fn init(renderer: *sdl.SDL_Renderer, width: i32, height: i32) !Texture {
        const texture = sdl.SDL_CreateTexture(renderer, sdl.SDL_PIXELFORMAT_RGBA8888, sdl.SDL_TEXTUREACCESS_STATIC, width, height) orelse {
            std.debug.print("Texture Creation failed: {s}\n", .{sdl.SDL_GetError()});
            return error.TextureCreationFailed;
        };

        return Texture{
            .texture = texture,
        };
    }

    pub fn fromFile(renderer: *sdl.SDL_Renderer, path: [*:0]const u8) !Texture {
        const texture = sdl.IMG_LoadTexture(renderer, path) orelse {
            std.debug.print("Texture Loading failed: {s}\n", .{sdl.SDL_GetError()});
            return error.TextureLoadingFailed;
        };

        return Texture{
            .texture = texture,
        };
    }

    pub fn fromBytes(renderer: *sdl.SDL_Renderer, bytes: []const u8) !Texture {
        const stream = sdl.SDL_IOFromConstMem(bytes.ptr, bytes.len) orelse {
            std.debug.print("IOStream Creation Failed: {s}\n", .{sdl.SDL_GetError()});
            return error.IOStreamCreationFailed;
        };

        const texture = sdl.IMG_LoadTexture_IO(renderer, stream, true) orelse {
            std.debug.print("Texture Loading failed: {s}\n", .{sdl.SDL_GetError()});
            return error.TextureLoadingFailed;
        };

        return Texture{
            .texture = texture,
        };
    }

    pub fn deinit(self: *const Texture) void {
        sdl.SDL_DestroyTexture(self.texture);
    }
};
