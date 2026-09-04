const sdl = @import("sdl");
const std = @import("std");
const crown = @import("crownlet");

const state = @import("../internal/state.zig");

pub const Texture = @import("texture.zig").Texture;
pub const Color = @import("color.zig").Color;

pub fn init() !void {
    state.renderer = sdl.SDL_CreateRenderer(state.window, null) orelse {
        std.debug.print("Renderer Error: {s}\n", .{sdl.SDL_GetError()});
        return error.RendererCreationFailed;
    };
}

pub fn deinit() void {
    sdl.SDL_DestroyRenderer(state.renderer);
}

pub fn clear(color: crown.graphics.Color) !void {
    if (!sdl.SDL_SetRenderDrawColor(state.renderer, color.r, color.g, color.b, color.a)) {
        std.debug.print("Clear failed: {s}\n", .{sdl.SDL_GetError()});
        return error.ClearFailed;
    }
    if (!sdl.SDL_RenderClear(state.renderer)) {
        std.debug.print("Clear failed: {s}\n", .{sdl.SDL_GetError()});
        return error.ClearFailed;
    }
}

pub fn present() !void {
    if (!sdl.SDL_RenderPresent(state.renderer)) {
        std.debug.print("Present failed: {s}\n", .{sdl.SDL_GetError()});
        return error.PresentFailed;
    }
}

pub fn setVSync(value: bool) !void {
    var value_int: c_int = 0;
    if (value) {
        value_int = 1;
    }

    if (!sdl.SDL_SetRenderVSync(state.renderer, value_int)) {
        return error.SettingVSyncFailed;
    }
}

pub fn loadTexture(bytes: []const u8) !Texture {
    const renderer = state.renderer;
    return Texture.fromBytes(renderer, bytes);
}

pub fn drawTexture(texture: Texture, x: f32, y: f32) !void {
    const renderer = state.renderer;

    var w: f32 = undefined;
    var h: f32 = undefined;
    _ = sdl.SDL_GetTextureSize(texture.texture, &w, &h);

    const dst = sdl.SDL_FRect{ .x = x, .y = y, .w = w, .h = h };

    if (!sdl.SDL_RenderTexture(renderer, texture.texture, null, &dst)) {
        std.debug.print("RenderTexture Error: {s}\n", .{sdl.SDL_GetError()});
        return error.RenderTextureFailed;
    }
}
