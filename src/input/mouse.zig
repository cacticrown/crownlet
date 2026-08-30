const sdl = @import("sdl");

pub const Button = enum(u32) {
    left = sdl.SDL_BUTTON_LMASK,
    middle = sdl.SDL_BUTTON_MMASK,
    right = sdl.SDL_BUTTON_RMASK,
    x1 = sdl.SDL_BUTTON_X1MASK,
    x2 = sdl.SDL_BUTTON_X2MASK,
};

var current_buttons: u32 = 0;
var previous_buttons: u32 = 0;
pub var x: f32 = 0;
pub var y: f32 = 0;

pub fn update() void {
    previous_buttons = current_buttons;
    current_buttons = sdl.SDL_GetMouseState(&x, &y);
}

pub fn buttonPressed(button: Button) bool {
    const mask = @intFromEnum(button);
    return (current_buttons & mask) != 0;
}

pub fn buttonJustPressed(button: Button) bool {
    const mask = @intFromEnum(button);

    const is_down_now = (current_buttons & mask) != 0;
    const was_down_before = (previous_buttons & mask) != 0;

    return is_down_now and !was_down_before;
}
