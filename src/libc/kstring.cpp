#include <cstdint>
#include <cstdarg>
#include <utility>
#include <kstring.hpp>
#include <stl/vector.hpp>
#include <net/net.hpp>

char* string::c_str_new() {
    return this->begin();
}
char* string::c_str_this() {
    if(!this->size() || this->back()) this->append(0);
    return this->begin();
}

template <container<char> C>
template <container<span<char>> CRet, container<char> CArg>
CRet basic_string<C>::split(const CArg any) const {
    istringstream stream(*this);
    basic_ostream<CRet, rostring> out;
    while(stream.readable()) {
        out.swrite(stream.read_until_any<rostring>(any));
        if (stream.readable() && any.contains(stream.front())) stream.read_c();
    }
    return out.data;
}

template <container<char> C>
template <container<span<char>> CRet>
CRet basic_string<C>::split(char c) const {
    return split(rostring(&c, 1));
}

template <container<char> C>
template <container<span<char>> CRet>
CRet basic_string<C>::split(const char* c) const {
    return split(rostring(c));
}

int formats(container_wrapper<char> output, const rostring fmt, ...) {
    va_list l;
    va_start(l, fmt);
    
    istringstream fmts(fmt);
    basic_ostringstream<container_wrapper<char>> ostr(output);

    const rostring fmtchars("ixXpbfsSIM");
    
    while (fmts.readable()) {
        char c = fmts.read_c();
        if (c == '%') {
            istringstream fmtArg(fmts.read_until_any<span<char>>(fmtchars, true));
            int leadingChars = 0;
            int decimals = 3;
            char leadingChar = ' ';

            while(fmtArg.readable()) {
                char front = fmtArg.front();
                if(fmtchars.contains(front)) break;
                else if (front == 'l' || front == 'z') fmtArg.read_c();
                else if (front == 'n') {
                    fmtArg.read_c();
                    leadingChars = va_arg(l, uint64_t);
                }
                else if (front == '.') {
                    fmtArg.read_c();
                    decimals = fmtArg.read_i();
                }
                else {
                    leadingChar = fmtArg.read_c();
                    leadingChars = fmtArg.read_i();
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
                ostr.write_c('0');
                ostr.write_c('x');
                ostr.write_u(va_arg(l, uint64_t), leadingChars, 16, leadingChar);
            }
            else if (c2 == 'b') {
                ostr.write_u(va_arg(l, uint64_t), leadingChars, 2, leadingChar);
            }
            else if (c2 == 'f') {
                ostr.write_f(va_arg(l, double), leadingChars, decimals, leadingChar);
            }
            else if (c2 == 's') {
                const char* ptr = va_arg(l, const char*);
                if (leadingChars) ostr.write_str(rostring((char*)ptr, leadingChars, 0));
                else ostr.write_cstr(ptr);
            }
            else if (c2 == 'S') {
                ostr.write_str(*va_arg(l, rostring*));
            }
            else if (c2 == 'I') {
                ipv4_t ip = va_arg(l, ipv4_t);
                for (int i = 0; i < 4; i++) {
                    ostr.write_i(((uint8_t*)&ip)[i]);
                    if (i < 3) ostr.write_c('.');
                }
            }
            else if (c2 == 'M') {
                mac_t mac = va_arg(l, mac_t);
                for (int i = 0; i < 6; i++) {
                    ostr.write_i(((uint8_t*)&mac)[i], 2, 16, '0', "0123456789abcdef");
                    if (i < 5) ostr.write_c(':');
                }
            }
        }
        else ostr.write_c(c);

    }
    va_end(l);
    
    output = std::move(ostr.data);
    return ostr.offset;
}

template <typename... Args> string format(rostring fmt, Args... args) {
    vector<char> v{};
    formats(v, fmt, args...);
    return string(v);
}
