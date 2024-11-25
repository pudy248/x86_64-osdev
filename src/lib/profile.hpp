#include <asm.hpp>

#define REP1(X) X
#define REP2(X) REP1(X) X
#define REP3(X) REP2(X) X
#define REP4(X) REP2(X) REP2(X)
#define REP5(X) REP4(X) X
#define REP10(X) REP2(REP5(X))
#define REP20(X) REP2(REP10(X))
#define REP50(X) REP5(REP10(X))
#define REP100(X) REP10(REP10(X))
#define REP200(X) REP2(REP100(X))
#define REP500(X) REP5(REP100(X))
#define REP1000(X) REP10(REP100(X))

#define PROFILE_LOOP(statement, var1stmt, var2stmt, how_many)   \
	var1stmt;                                                   \
	for (std::size_t _Index = 0; _Index < how_many; _Index++) { \
		statement;                                              \
	}                                                           \
	var2stmt;
#define PROFILE_PRECISE(statement, var1, var2, how_many) \
	[[clang::noinline]][&]() {                           \
		var1 = rdtsc();                                  \
		REP##how_many(statement;);                       \
		var2 = rdtsc();                                  \
	}                                                    \
	()
