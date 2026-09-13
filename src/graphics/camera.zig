const crown = @import("crownlet");

pub const Camera = struct {
    position: crown.math.Vector2 = .{ .x = 0, .y = 0 },
    offset: crown.math.Vector2 = .{ .x = 0, .y = 0 },
    zoom: f32 = 1.0,
};
