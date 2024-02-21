#pragma once
#include <cstdint>
#include <kstddefs.h>
#include <kcstring.h>
#include <stl/vector.hpp>

template <container<char> C>
class basic_string : public C {
public:
    using C::C;
	template <container<char> C2> basic_string(const C2& other) : basic_string(other.begin(), other.end()) { }
    constexpr basic_string& operator=(const basic_string& other) = default;
    constexpr basic_string& operator=(basic_string&& other) = default;

    constexpr basic_string(const char* cstr) : basic_string(cstr, strlen(cstr), 0) { }
    constexpr basic_string(const basic_string& str) : basic_string(str.begin(), str.end()) { }
    
    template <container<span<char>> CRet = vector<span<char>>, container<char> CArg>
    CRet split(const CArg any) const;
    template <container<span<char>> CRet = vector<span<char>>>
    CRet split(char c) const;
    template <container<span<char>> CRet = vector<span<char>>>
    CRet split(const char* c) const;
};

class rostring : public basic_string<span<char>> {
public:
	using basic_string<span<char>>::basic_string;

	template <container<char> C2>
    constexpr rostring(const C2& other) : rostring(other.begin(), other.end()) { }
};
class string : public basic_string<vector<char>> {
public:
	using basic_string<vector<char>>::basic_string;
	template <container<char> C2>
    string(const C2& other) : string(other.begin(), other.end()) { }

    char* c_str_this();
    char* c_str_new();
};

constexpr rostring operator""_RO(const char* literal, uint64_t x) {
    return rostring(literal);
}

template <typename C>
class basic_ostringstream : public basic_ostream<C, char> {
public:
    template <container<char> C2>
    constexpr basic_ostringstream(C2&& s) : basic_ostream<C, char>(s) {}

    void bzwrite(const void* dat, int size) {
        const char* str = (const char*)dat;
        for (int i = 0; i < size; i++) {
            this->swrite(str[i]);
        }
    }
    template <typename D> void bwrite(const D dat) {
        bzwrite(&dat, sizeof(D));
    }

    void write_c(char dat) {
        this->swrite(dat);
    }
    void write_cstr(const char* dat) {
        bzwrite(dat, strlen(dat));
    }
    void write_str(const rostring dat) {
        bzwrite(dat.begin(), dat.size());
    }
    void write_u(uint64_t n, int leading = 0, int radix = 10, char leadChar = ' ', const char* letters = "0123456789ABCDEF") {
        uint64_t tmp = n;
        int ctr = 0;
        do {
            tmp /= radix;
            ctr++;
        } while (tmp > 0);
        int tmpctr = ctr--;

        for (int i = 0; i < leading - ctr; i++)
            write_c(leadChar);
        
        basic_string<array<char, 25>> tmpstr;
        do {
            tmpstr.at(ctr--) = letters[n % radix];
            n /= radix;
        } while (n > 0);
        bzwrite(tmpstr.begin(), tmpctr);
    }
    void write_i(int64_t n, int leading = 0, int radix = 10, char leadChar = ' ', const char* letters = "0123456789ABCDEF") {
        if (n < 0) {
            n = -n;
            write_c('-');
            leading--;
        }
        write_u(n, leading, radix, leadChar, letters);
    }
    void write_f(double n, int leading = 0, int trailing = 3, char leadChar = ' ') {
        if ((((uint32_t*)&n)[1] & 0x7ff00000) == 0x7ff00000) {
            write_c('N');
            write_c('a');
            write_c('N');
            return;
        }
        if (n < 0) {
            n = -n;
            write_c('-');
        }
        double tmp = n;
        int ctr = 0;
        do {
            tmp /= 10;
            ctr++;
        } while ((int)tmp > 0);
        int tmpctr = ctr--;

        for (int i = 0; i < leading - ctr; i++)
            write_c(leadChar);
        
        basic_string<array<char, 15>> tmpstr;
        tmp = n;
        do {
            tmpstr.at(ctr--) = '0' + (int)tmp % 10;
            tmp /= 10;
        } while ((int)tmp > 0);
        bzwrite(tmpstr.begin(), tmpctr);

        if (trailing > 0) {
            write_c('.');

            tmp = n - (int)n;
            for (int i = 0; i < trailing; i++) {
                tmp *= 10;
                tmpstr.at(i) = '0' + (int)tmp % 10 + (i == trailing - 1);
            }
            bzwrite(tmpstr.begin(), trailing);
        }
    }
};

template <typename C>
class basic_istringstream : public basic_istream<C, char> {
public:
    template <container<char> C2>
    constexpr basic_istringstream(const C2& s) : basic_istream<C, char>(s) {}
    template <container<char> C2>
    constexpr basic_istringstream(C2&& s) : basic_istream<C, char>(s) {}

    void bzread(void* dat, int size) {
        for (int i = 0; i < size; i++) {
            ((char*)dat)[i] = this->data.at(this->offset++);
        }
    }
    template <typename D> D bread() {
        D ret;
        bzread(&ret, sizeof(D));
        return ret;
    }

    char read_c() {
        return this->sread();
    }
    int64_t read_i() {
        int64_t val = 0;
        char neg = 0;
        if (this->front() == '-') {
            neg = 1;
            read_c();
        }
        while (this->front() >= '0' && this->front() <= '9') {
            val *= 10;
            val += read_c() - '0';
        }
        if (neg) val = -val;
        return val;
    }
    double read_f() {
        constexpr int trailingMax = 10;
        double val = 0;
        int afterDecimal = 0;
        char neg = 0;
        if (this->front() == '-') {
            neg = 1;
            read_c();
        }
        while (this->front() >= '0' && this->front() <= '9') {
            val *= 10;
            val += read_c() - '0';
        }
        if (this->front() == '.') {
            read_c();
            double multiplier = 0.1;
            while (this->front() >= '0' && this->front() <= '9' && afterDecimal < trailingMax) {
                afterDecimal++;
                val += (read_c() - '0') * multiplier;
                multiplier *= 0.1;
            }
        }
        if (neg) val = -val;
        return val;
    }

	template<container<char> C2, container<char> C3>
    const C2 read_until_any(const C3 any, bool inclusive = false) {
        int sIdx = this->offset;
        while (this->readable() && !any.contains(this->data.at(this->offset)))
            this->offset++;
        if (inclusive && this->readable()) this->offset++;
        return C2(this->data, this->offset - sIdx, sIdx);
    }
    template<container<char> C2, container<char> C3, container<C3> C4>
    const C2 read_until_any(const C4 any, bool inclusive = false) {
        int sIdx = this->offset;
        while (this->readable()) {
            bool stop = false;
            for (int i = 0; i < any.size(); i++) {
                if (this->data.starts_with(any[i]))
                    stop = true;
            }
            if (stop) break;
            this->offset++;
        }
        if (inclusive && this->readable()) this->offset++;
        return C2(this->data, this->offset - sIdx, sIdx);
    }
};
class ostringstream : public basic_ostringstream<string> {
public:
    using basic_ostringstream<string>::basic_ostringstream;
	template <container<char> C2> ostringstream(const C2& other) : basic_ostringstream<string>(other) { }
};
class istringstream : public basic_istringstream<rostring> {
public:
    using basic_istringstream<rostring>::basic_istringstream;
	template <container<char> C2> istringstream(const C2& other) : basic_istringstream<rostring>(other) { }
};

template <container<char> C> int formats(C& output, const rostring fmt, ...);
template <typename... Args> string format(rostring fmt, Args... args);