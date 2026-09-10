const std = @import("std");

pub const Vector2 = struct {
    x: f32 = 0.0,
    y: f32 = 0.0,

    pub fn init(x: f32, y: f32) Vector2 {
        return .{ .x = x, .y = y };
    }

    pub fn add(self: Vector2, other: Vector2) Vector2 {
        return .{
            .x = self.x + other.x,
            .y = self.y + other.y,
        };
    }

    pub fn sub(self: Vector2, other: Vector2) Vector2 {
        return .{
            .x = self.x - other.x,
            .y = self.y - other.y,
        };
    }

    pub fn scale(self: Vector2, scalar: f32) Vector2 {
        return .{
            .x = self.x * scalar,
            .y = self.y * scalar,
        };
    }

    pub fn dot(self: Vector2, other: Vector2) f32 {
        return (self.x * other.x) + (self.y * other.y);
    }

    pub fn lengthSq(self: Vector2) f32 {
        return self.dot(self);
    }

    pub fn length(self: Vector2) f32 {
        return @sqrt(self.lengthSq());
    }

    pub fn normalize(self: Vector2) Vector2 {
        const len = self.length();
        if (len == 0.0) return .{ .x = 0.0, .y = 0.0 };
        return .{
            .x = self.x / len,
            .y = self.y / len,
        };
    }
};

test "Vector2 initialization" {
    const v = Vector2.init(3.0, 4.0);
    try std.testing.expectEqual(@as(f32, 3.0), v.x);
    try std.testing.expectEqual(@as(f32, 4.0), v.y);

    const default_v = Vector2{};
    try std.testing.expectEqual(@as(f32, 0.0), default_v.x);
    try std.testing.expectEqual(@as(f32, 0.0), default_v.y);
}

test "Vector2 addition and subtraction" {
    const a = Vector2.init(1.0, 2.0);
    const b = Vector2.init(3.0, 4.0);

    const added = a.add(b);
    try std.testing.expectEqual(@as(f32, 4.0), added.x);
    try std.testing.expectEqual(@as(f32, 6.0), added.y);

    const subtracted = a.sub(b);
    try std.testing.expectEqual(@as(f32, -2.0), subtracted.x);
    try std.testing.expectEqual(@as(f32, -2.0), subtracted.y);
}

test "Vector2 scaling" {
    const v = Vector2.init(2.0, -3.0);
    const scaled = v.scale(2.5);

    try std.testing.expectEqual(@as(f32, 5.0), scaled.x);
    try std.testing.expectEqual(@as(f32, -7.5), scaled.y);
}

test "Vector2 dot product" {
    const a = Vector2.init(2.0, 3.0);
    const b = Vector2.init(4.0, -1.0);

    const result = a.dot(b);
    try std.testing.expectEqual(@as(f32, 5.0), result);
}

test "Vector2 length and lengthSq" {
    const v = Vector2.init(3.0, 4.0);

    try std.testing.expectEqual(@as(f32, 25.0), v.lengthSq());
    try std.testing.expectEqual(@as(f32, 5.0), v.length());
}

test "Vector2 normalize" {
    const v = Vector2.init(3.0, 4.0);
    const norm = v.normalize();

    try std.testing.expectApproxEqAbs(@as(f32, 0.6), norm.x, 0.0001);
    try std.testing.expectApproxEqAbs(@as(f32, 0.8), norm.y, 0.0001);
    try std.testing.expectApproxEqAbs(@as(f32, 1.0), norm.length(), 0.0001);

    const zero = Vector2.init(0.0, 0.0);
    const norm_zero = zero.normalize();
    try std.testing.expectEqual(@as(f32, 0.0), norm_zero.x);
    try std.testing.expectEqual(@as(f32, 0.0), norm_zero.y);
}
