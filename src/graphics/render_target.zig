const std = @import("std");
const sdl = @import("sdl");

pub const RenderTarget = struct {
    texture: *sdl.SDL_Texture,

    pub fn init(renderer: *sdl.SDL_Renderer, width: i32, height: i32) !RenderTarget {
        const texture = sdl.SDL_CreateTexture(renderer, sdl.SDL_PIXELFORMAT_RGBA8888, sdl.SDL_TEXTUREACCESS_TARGET, width, height) orelse {
            std.debug.print("Texture Creation failed: {s}\n", .{sdl.SDL_GetError()});
            return error.RenderTargetCreationFailed;
        };

        return RenderTarget{
            .texture = texture,
        };
    }

    pub fn deinit(self: *const RenderTarget) void {
        sdl.SDL_DestroyTexture(self.texture);
    }

    pub fn getSize(self: *const RenderTarget) !type {
        var width: f32 = undefined;
        var height: f32 = undefined;
        if (!sdl.SDL_GetTextureSize(self, &width, &height)) {
            return error.GettingTextureSizeFailed;
        }
        return .{
            .width = width,
            .height = height,
        };
    }
};
