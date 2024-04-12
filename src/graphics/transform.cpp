#include <graphics/math.hpp>
#include <graphics/transform.hpp>
#include <graphics/vectypes.hpp>

Mat4x4 identity() {
	return (Mat4x4){ {
		1,
		0,
		0,
		0,
		0,
		1,
		0,
		0,
		0,
		0,
		1,
		0,
		0,
		0,
		0,
		1,
	} };
}
Mat4x4 translate(float dx, float dy, float dz) {
	return (Mat4x4){ {
		1,
		0,
		0,
		dx,
		0,
		1,
		0,
		dy,
		0,
		0,
		1,
		dz,
		0,
		0,
		0,
		1,
	} };
}
Mat4x4 rotate(float tx, float ty, float tz) {
	float sx, cx, sy, cy, sz, cz;
	cossinf(tx, &cx, &sx);
	cossinf(ty, &cy, &sy);
	cossinf(tz, &cz, &sz);

	Mat4x4 p123 = { {
		cy * cz,
		-cy * sz,
		sy,
		0,
		cx * sz + cz * sx * sy,
		cx * cz - sx * sy * sz,
		-cy * sx,
		0,
		sx * sz - cx * cz * sy,
		cx * sy * sz + cz * sx,
		cx * cy,
		0,
		0,
		0,
		0,
		1,
	} };
	return p123;
}
Mat4x4 scale(float f) {
	return (Mat4x4){ {
		f,
		0,
		0,
		0,
		0,
		f,
		0,
		0,
		0,
		0,
		f,
		0,
		0,
		0,
		0,
		1,
	} };
}
Mat4x4 rebase(Vec3 up, Vec3 forward, Vec3 pos) {
	Vec3 nd = norm3(forward);
	Vec3 nu = norm3(up);
	Vec3 r = cross(nd, nu);
	Vec3 u = cross(r, nd);
	return (Mat4x4){ {
		r.x,
		r.y,
		r.z,
		dot(r, mul3(pos, -1)),
		u.x,
		u.y,
		u.z,
		dot(u, mul3(pos, -1)),
		-nd.x,
		-nd.y,
		-nd.z,
		dot(nd, mul3(pos, -1)),
		0,
		0,
		0,
		1,
	} };
}
Mat4x4 project(float nw, float nh, float n) {
	return (Mat4x4){ {
		2 * n / nw,
		0,
		0,
		0,
		0,
		2 * n / nh,
		0,
		0,
		0,
		0,
		-1,
		0,
		0,
		0,
		-1,
		0,
	} };
}
Vec4 vnormw(Vec4 a) {
	return (Vec4){ a.x / a.w, a.y / a.w, a.z / a.w, a.w };
}
