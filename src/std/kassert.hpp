#pragma once
#include <asm.hpp>
#include <kstdlib.hpp>

void wait_until_kbhit();
void inline_stacktrace();
void print(const char*);
void tag_dump();

enum DEBUG_SEVERITY {
	CATCH_FIRE,
	TASK_EXCEPTION,
	ERROR,
	WARNING,
	INFO,
	COMMENT,
	IGNORE,
};
enum DEBUG_LEVEL {
	UNMASKABLE,
	ALWAYS_ACTIVE,
	DEBUG_ONLY,
	DEBUG_VERBOSE,
};

namespace assert {
constexpr int DEFAULT_DEBUG_LEVEL = DEBUG_VERBOSE;
constexpr int DEFAULT_DEBUG_HALT_SEVERITY = ERROR;
constexpr int DEFAULT_DEBUG_PAUSE_SEVERITY = WARNING;
constexpr int DEFAULT_DEBUG_IGNORE_SEVERITY = COMMENT;

#ifndef NDEBUG_LEVEL
#define NDEBUG_LEVEL assert::DEFAULT_DEBUG_LEVEL
#warning "User should define a debug level. Defaulting to ALWAYS_ACTIVE only."
#endif

#ifndef NDEBUG_HALT_SEVERITY
#define NDEBUG_HALT_SEVERITY assert::DEFAULT_DEBUG_HALT_SEVERITY
#endif

#ifndef NDEBUG_PAUSE_SEVERITY
#define NDEBUG_PAUSE_SEVERITY assert::DEFAULT_DEBUG_PAUSE_SEVERITY
#endif

#ifndef NDEBUG_IGNORE_SEVERITY
#define NDEBUG_IGNORE_SEVERITY assert::DEFAULT_DEBUG_IGNORE_SEVERITY
#endif

static const char* debug_severities[] = {
	"halt and catch fire!! ", "fatal exception: ", "error: ", "warning: ", "info: ", "note: ", ""
};

template <bool halt>
[[gnu::used]] static void kassert_impl(int severity, const char* location, const char* message) {
	print(debug_severities[severity]);
	print(location);
	print(": ");
	print(message);
	inline_stacktrace();
	for (int i = 0; i < 30000000; i++) cpu_relax();
	tag_dump();
	//if (severity <= NDEBUG_PAUSE_SEVERITY) {
	//	wait_until_kbhit();
	//}
	if constexpr (halt) {
		inf_wait();
		__builtin_unreachable();
	}
}
}

#define STRINGIZE(x) STRINGIZE2(x)
#define STRINGIZE2(x) #x
#define kassert(level, severity, condition, msg)                                  \
	do {                                                                          \
		if constexpr (level <= NDEBUG_LEVEL && severity < NDEBUG_IGNORE_SEVERITY) \
			if (!(condition))                                                     \
				assert::kassert_impl<(severity < NDEBUG_HALT_SEVERITY)>(          \
					severity, __FILE__ ":" STRINGIZE(__LINE__), msg);             \
	} while (0)

#define kassert_trace(level, severity)                                            \
	do {                                                                          \
		if constexpr (level <= NDEBUG_LEVEL && severity < NDEBUG_IGNORE_SEVERITY) \
			assert::kassert_impl<(severity < NDEBUG_HALT_SEVERITY)>(              \
				severity, __FILE__ ":" STRINGIZE(__LINE__), "Backtrace");         \
	} while (0)