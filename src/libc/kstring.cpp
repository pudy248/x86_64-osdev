#pragma once
#include <cstdint>
#include <cstdarg>
#include <utility>
#include <kstddefs.h>
#include <kcstring.h>
#include <kstring.hpp>
#include <kstdio.hpp>
#include <sys/global.h>
#include <stl/vector.hpp>
#include <net/net.hpp>

rostring::rostring(const char* str, int length, int offset) : span<char>(str, length, offset) {}
rostring::rostring(const char* cstr) : rostring(cstr, strlen(cstr), 0) {}
rostring::rostring(const span<char>& vec, int length, int offset) : span<char>(vec, length, offset) {}
rostring::rostring(const span<char>& vec) : rostring(vec, vec.size(), 0) {}

string::string(const char* str, int length, int offset) : vector<char>(span<char>(str, length, offset)) {}
string::string(const char* cstr) : string(cstr, strlen(cstr), 0) {}
string::string(const string& str, int length, int offset) : vector<char>(span<char>(str.m_arr, length, offset)) {}
string::string(const string& str) : string(str, str.size(), 0) {}
string::string(const span<char>& vec, int length, int offset) : vector<char>(span<char>(vec, length, offset)) {}
string::string(const span<char>& vec) : string(vec, vec.size(), 0) {}
string::operator rostring() const { return rostring(this->m_arr, this->m_length); }
char* string::c_str_new() {
    return this->c_arr();
}
char* string::c_str_this() {
    if(!this->size() || this->back()) this->append(0);
    return this->unsafe_arr();
}

void ostringstream::write_bz(const void* dat, int size) {
    for(int i = 0; i < size; i++) {
        data.append(((const char*)dat)[i]);
    }
}
template<> void ostringstream::write(char dat) {
    write_b<char>(dat);
}
template<> void ostringstream::write(const char* dat) {
    write_bz(dat, strlen(dat));
}
template<> void ostringstream::write(const rostring dat) {
    write_bz(dat.unsafe_arr(), dat.size());
}
template<> void ostringstream::write(const string dat) {
    write<rostring>(dat);
}
template<> void ostringstream::write(int64_t dat) {
    write_i(dat);
}
template<> void ostringstream::write(double dat) {
    write_d(dat);
}

void ostringstream::write_u(uint64_t n, int leading, int radix, char leadChar, const char* letters) {
    uint64_t tmp = n;
    int ctr = 0;
    do {
        tmp /= radix;
        ctr++;
    } while (tmp > 0);

    for (int i = 0; i < leading - ctr; i++)
        write<char>(leadChar);

    string tmpstr;
    tmpstr.reserve(ctr);

    do {
        uint64_t rem = n % radix;
        tmpstr.insert(letters[rem], 0);
        n /= radix;
    } while (n > 0);
    write<string>(tmpstr);
}
void ostringstream::write_i(int64_t n, int leading, int radix, char leadChar, const char* letters) {
    if (n < 0) {
        n = -n;
        write<char>('-');
        leading--;
    }
    write_u(n, leading, radix, leadChar, letters);
}
void ostringstream::write_d(double n, int leading, int trailing, char leadChar) {
    if ((((uint32_t*)&n)[1] & 0x7ff00000) == 0x7ff00000) {
        write<const char*>("NaN");
        return;
    }
    if (n < 0) {
        n = -n;
        write<char>('-');
    }
    double tmp = n;
    int ctr = 0;
    do {
        tmp /= 10;
        ctr++;
    } while (tmp > 0);

    for (int i = 0; i < leading - ctr; i++)
        write<char>(leadChar);

    string tmpstr;
    tmp = n;
    do {
        int rem = (int)tmp % 10;
        tmpstr.insert('0' + rem, 0);
        tmp /= 10;
    } while ((int)tmp > 0);
    write<string>(tmpstr);

    if (trailing > 0) {
        write<char>('.');

        tmpstr.clear();
        tmp = n - (int)n;
        for (int i = 0; i < trailing; i++) {
            tmp *= 10;
            int rem = (int)tmp % 10;
            tmpstr.insert('0' + rem, 0);
        }
        write<string>(tmpstr);
    }
}

istringstream::istringstream(const rostring s) : istream<char>(s) {}
istringstream::operator rostring() const { return rostring(this->data, this->data.size() - idx, idx); }
void istringstream::read_bz(void* dat, int size) {
    for (int i = 0; i < size; i++) {
        ((char*)dat)[i] = data.at(idx++);
    }
}
template<> char istringstream::read<char>() {
    return this->sread();
}
template<> double istringstream::read<double>(){
    constexpr int trailingMax = 10;
    double val = 0;
    int afterDecimal = 0;
    char neg = 0;
    if (read_c<char>() == '-') {
        neg = 1;
        read<char>();
    }
    while (read_c<char>() >= '0' && read_c<char>() <= '9') {
        val *= 10;
        val += read<char>() - '0';
    }
    if (read_c<char>() == '.') {
        read<char>();
        double multiplier = 0.1;
        while (read_c<char>() >= '0' && read_c<char>() <= '9' && afterDecimal < trailingMax) {
            afterDecimal++;
            val += (read<char>() - '0') * multiplier;
            multiplier *= 0.1;
        }
    }
    if (neg) val = -val;
    return val;
}
template<> int64_t istringstream::read<int64_t>(){
    int64_t val = 0;
    char neg = 0;
    if (read_c<char>() == '-') {
        neg = 1;
        read<char>();
    }
    while (read_c<char>() >= '0' && read_c<char>() <= '9') {
        val *= 10;
        val += read<char>() - '0';
    }
    if (neg) val = -val;
    return val;
}
const rostring istringstream::read_until_any_inc(const rostring any) {
    int sIdx = idx;
    while (!any.contains(data.at(idx)) && readable())
        idx++;
    if (readable()) idx++;
    return rostring(data, idx - sIdx, sIdx);
}

const rostring istringstream::read_until_any(const rostring any) {
    int sIdx = idx;
    while (!any.contains(data.at(idx)) && readable())
        idx++;
    return rostring(data, idx - sIdx, sIdx);
}
const rostring istringstream::read_until_any(span<rostring> any) {
    int sIdx = idx;
    while (readable()) {
        bool stop = false;
        for (int i = 0; i < any.size(); i++) {
            if (data.starts_with(any[i]))
                stop = true;
        }
        if (stop) break;
        idx++;
    }
    return rostring(data, idx - sIdx, sIdx);
}
const rostring istringstream::read_until_inc(char c) {
    return this->read_until_any_inc(span<char>(&c, 1));
}
const rostring istringstream::read_until(char c) {
    return this->read_until_any(span<char>(&c, 1));
}
const rostring istringstream::read_while(bool(*condition)(rostring)) {
    int sIdx = idx;
    while (readable() && condition(*this))
        idx++;
    return rostring(data, idx - sIdx, sIdx);
}
const rostring istringstream::read_until(bool(*condition)(rostring)) {
    int sIdx = idx;
    while (readable() && !condition(*this))
        idx++;
    return rostring(data, idx - sIdx, sIdx);
}



vector<rostring> rostring::split(const rostring any) const {
    istringstream stream(*this);
    vector<rostring> out;
    while(stream.readable()) {
        out.append(stream.read_until_any(any));
        if (any.contains(stream.read_c<char>())) stream.read<char>();
    }
    return out;
}
vector<rostring> rostring::split(char c) const {
    return split(rostring(&c, 1));
}

int formats(vector<char>& output, const rostring fmt, ...) {
    va_list l;
    va_start(l, fmt);
    
    istringstream fmts(fmt);
    ostringstream ostr;
    ostr.data = std::move(output);

    const rostring fmtchars("ixXpbfsSIM");
    
    while (fmts.readable()) {
        char c = fmts.read<char>();
        if (c == '%') {
            istringstream fmtArg(fmts.read_until_any_inc(fmtchars));
            int leadingChars = 0;
            int decimals = 3;
            char leadingChar = ' ';

            while(fmtArg.readable()) {
                char front = fmtArg.read_c<char>();
                if(fmtchars.contains(front)) break;
                else if (front == 'l' || front == 'z') fmtArg.read<char>();
                else if (front == 'n') {
                    fmtArg.read<char>();
                    leadingChars = va_arg(l, uint64_t);
                }
                else if (front == '.') {
                    fmtArg.read<char>();
                    decimals = fmtArg.read<int64_t>();
                }
                else {
                    leadingChar = fmtArg.read<char>();
                    leadingChars = fmtArg.read<int64_t>();
                }
            }
            char c2 = fmtArg.data.at(fmtArg.data.size() - 1);
            if (c2 == 'i') {
                ostr.write_i(va_arg(l, int64_t), leadingChars, 10, leadingChar);
            }
            else if (c2 == 'X') {
                ostr.write_u(va_arg(l, uint64_t), leadingChars, 16, leadingChar);
            }
            else if (c2 == 'x') {
                ostr.write_u(va_arg(l, uint64_t), leadingChars, 16, leadingChar, "0123456789abcdef");
            }
            else if (c2 == 'p') {
                ostr.write<const char*>("0x");
                ostr.write_u(va_arg(l, uint64_t), leadingChars, 16, leadingChar);
            }
            else if (c2 == 'b') {
                ostr.write_u(va_arg(l, uint64_t), leadingChars, 2, leadingChar);
            }
            else if (c2 == 'f') {
                ostr.write_d(va_arg(l, double), leadingChars, decimals, leadingChar);
            }
            else if (c2 == 's') {
                const char* ptr = va_arg(l, const char*);
                if (leadingChars) ostr.write<rostring>(rostring(ptr, leadingChars));
                else ostr.write<const char*>(ptr);
            }
            else if (c2 == 'S') {
                ostr.write<rostring>(*va_arg(l, rostring*));
            }
            else if (c2 == 'I') {
                ipv4_t ip = va_arg(l, ipv4_t);
                for (int i = 0; i < 4; i++) {
                    ostr.write_i(((uint8_t*)&ip)[i]);
                    if (i < 3) ostr.write<char>('.');
                }
            }
            else if (c2 == 'M') {
                mac_t mac = va_arg(l, mac_t);
                for (int i = 0; i < 6; i++) {
                    ostr.write_i(((uint8_t*)&mac)[i], 2, 16, '0', "0123456789abcdef");
                    if (i < 5) ostr.write<char>(':');
                }
            }
        }
        else ostr.write<char>(c);

    }
    va_end(l);
    
    output = std::move(ostr.data);
    return output.size();
}
template <typename... Args> int formats(char* output, int output_size, const rostring fmt, Args... args) {
    vector<char> v;
    v.unsafe_set(output, 0, output_size);
    return formats(v, fmt, args...);
}

template <typename... Args> string format(rostring fmt, Args... args) {
    vector<char> v{};
    formats(v, fmt, args...);
    return string(v);
}
