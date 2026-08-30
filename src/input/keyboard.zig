const std = @import("std");
const sdl = @import("sdl");

pub const Keycode = @import("keycode.zig").Keycode;

var current_keyboard_state: [512]bool = [_]bool{false} ** 512;
var previous_keyboard_state: [512]bool = [_]bool{false} ** 512;

pub fn update() void {
    previous_keyboard_state = current_keyboard_state;

    var num_keys: c_int = 0;
    const state_ptr = sdl.SDL_GetKeyboardState(&num_keys);

    if (state_ptr != null) {
        const count = @as(usize, @intCast(num_keys));
        const limit = @min(count, current_keyboard_state.len);

        const sdl_slice = state_ptr[0..limit];
        @memcpy(current_keyboard_state[0..limit], sdl_slice);
    }
}

pub fn keyPressed(key: Keycode) bool {
    const index = @as(usize, @intFromEnum(key));
    if (index < current_keyboard_state.len) {
        return current_keyboard_state[index];
    }
    return false;
}

pub fn keyJustPressed(key: Keycode) bool {
    const index = @as(usize, @intFromEnum(key));
    if (index < current_keyboard_state.len) {
        return current_keyboard_state[index] and !previous_keyboard_state[index];
    }
    return false;
}
