const sdl = @import("sdl");
const std = @import("std");
const crown = @import("crownlet");

const state = @import("../internal/state.zig");

pub const Texture = @import("texture.zig").Texture;
pub const RenderTarget = @import("render_target.zig").RenderTarget;
pub const Color = @import("color.zig").Color;

var begin_called = false;
var current_texture_filter: TextureFilter = .linear;

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
    if (!begin_called) {
        return error.BeginNotCalled;
    }
    if (!sdl.SDL_SetRenderDrawColor(state.renderer, color.r, color.g, color.b, color.a)) {
        std.debug.print("Clear failed: {s}\n", .{sdl.SDL_GetError()});
        return error.ClearFailed;
    }
    if (!sdl.SDL_RenderClear(state.renderer)) {
        std.debug.print("Clear failed: {s}\n", .{sdl.SDL_GetError()});
        return error.ClearFailed;
    }
}

pub const PassOptions = struct {
    target: ?RenderTarget = null,
    texture_filter: TextureFilter = TextureFilter.linear,
};

pub const TextureFilter = enum {
    nearest,
    linear,
};

pub fn begin(options: PassOptions) !void {
    if (begin_called) {
        return error.BeginAlreadyCalled;
    }
    begin_called = true;

    current_texture_filter = options.texture_filter;

    const target_texture = if (options.target) |t| t.texture else null;

    if (!sdl.SDL_SetRenderTarget(state.renderer, target_texture)) {
        std.debug.print("Setting Render Target failed: {s}\n", .{sdl.SDL_GetError()});
        return error.SetRenderTargetFailed;
    }
}

pub fn end() !void {
    if (!begin_called) {
        return error.BeginNotCalled;
    }
    begin_called = false;

    if (sdl.SDL_GetRenderTarget(state.renderer) != null) {
        return;
    }

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

pub fn setLogicalPresentation(width: i32, height: i32, mode: LogicalRepresentation) !void {
    const sdl_mode = switch (mode) {
        .disabled => sdl.SDL_LOGICAL_PRESENTATION_DISABLED,
        .stretch => sdl.SDL_LOGICAL_PRESENTATION_STRETCH,
        .letterbox => sdl.SDL_LOGICAL_PRESENTATION_LETTERBOX,
        .overscan => sdl.SDL_LOGICAL_PRESENTATION_OVERSCAN,
        .integer_scale => sdl.SDL_LOGICAL_PRESENTATION_INTEGER_SCALE,
    };

    if (!sdl.SDL_SetRenderLogicalPresentation(state.renderer, width, height, @intCast(sdl_mode))) {
        std.debug.print("Setting logical presentation failed: {s}\n", .{sdl.SDL_GetError()});
        return error.SettingLogicalPresentationFailed;
    }
}

pub fn createRenderTarget(width: i32, height: i32) !RenderTarget {
    return RenderTarget.init(state.renderer, width, height);
}

pub fn createTexture(width: i32, height: i32) !Texture {
    return Texture.init(state.renderer, width, height);
}

pub fn loadTextureFromBytes(bytes: []const u8) !Texture {
    return Texture.fromBytes(state.renderer, bytes);
}

pub fn loadTextureFromFile(path: [*:0]const u8) !Texture {
    return Texture.fromFile(state.renderer, path);
}

pub fn drawTexture(texture: Texture, position: crown.math.Vector2) !void {
    try drawSdlTexture(texture.texture, position);
}

pub fn drawRenderTarget(renderTarget: RenderTarget, position: crown.math.Vector2) !void {
    try drawSdlTexture(renderTarget.texture, position);
}

fn drawSdlTexture(texture: *sdl.SDL_Texture, position: crown.math.Vector2) !void {
    if (!begin_called) {
        return error.BeginNotCalled;
    }

    const renderer = state.renderer;

    const sdl_texture_filter = switch (current_texture_filter) {
        .nearest => sdl.SDL_SCALEMODE_NEAREST,
        .linear => sdl.SDL_SCALEMODE_LINEAR,
    };

    if (!sdl.SDL_SetTextureScaleMode(texture, sdl_texture_filter)) {
        std.debug.print("Setting Texture Filter failed: {s}\n", .{sdl.SDL_GetError()});
        return error.SettingsTextureFilterFailed;
    }

    var w: f32 = undefined;
    var h: f32 = undefined;
    _ = sdl.SDL_GetTextureSize(texture, &w, &h);

    const dst = sdl.SDL_FRect{ .x = position.x, .y = position.y, .w = w, .h = h };

    if (!sdl.SDL_RenderTexture(renderer, texture, null, &dst)) {
        std.debug.print("Rendering Texture failed: {s}\n", .{sdl.SDL_GetError()});
        return error.RenderTextureFailed;
    }
}

pub const LogicalRepresentation = enum {
    disabled,
    stretch,
    letterbox,
    overscan,
    integer_scale,
};
