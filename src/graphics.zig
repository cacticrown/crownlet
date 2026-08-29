const internalWindow = @import("internal/sdl_window.zig");
const sdl = @import("sdl");
const std = @import("std");

pub const Texture = @import("texture.zig").Texture;

pub fn loadTexture(bytes: []const u8) !Texture {
    const renderer = internalWindow.current.renderer;
    return Texture.fromBytes(renderer, bytes);
}

pub fn drawTexture(texture: Texture, x: f32, y: f32) !void {
    const renderer = internalWindow.current.renderer;

    var w: f32 = undefined;
    var h: f32 = undefined;
    _ = sdl.SDL_GetTextureSize(texture.texture, &w, &h);

    const dst = sdl.SDL_FRect{ .x = x, .y = y, .w = w, .h = h };

    if (!sdl.SDL_RenderTexture(renderer, texture.texture, null, &dst)) {
        std.debug.print("RenderTexture Error: {s}\n", .{sdl.SDL_GetError()});
        return error.RenderTextureFailed;
    }
}
