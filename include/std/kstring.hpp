#pragma once
#include <kstddefs.h>
#include <stl/vector.hpp>

class rostring : public span<char> {
public:
    rostring() = default;
    rostring(rostring&& other) = default;
    rostring& operator=(const rostring& other) = default;
    rostring& operator=(rostring&& other) = default;

    rostring(const char* str, int length, int offset = 0);
    rostring(const char* cstr);
    constexpr rostring(const rostring& str, int length, int offset = 0) : span<char>(str, length, offset) {}
    constexpr rostring(const rostring& str) : rostring(str, str.size(), 0) {}
    rostring(const span<char>& vec, int length, int offset = 0);
    rostring(const span<char>& vec);

    constexpr bool operator==(const rostring other) const { return starts_with(other) && size() == other.size(); }
    constexpr bool operator!=(const rostring other) const { return !(*this == other); }
    
    vector<rostring> split(const rostring any) const;
    vector<rostring> split(char c) const;
};

class string : public vector<char> {
public:
    string() = default;
    string(string&& other) = default;
    string& operator=(const string& other) = default;
    string& operator=(string&& other) = default;

    string(const char* str, int length, int offset = 0);
    string(const char* cstr);
    string(const string& str, int length, int offset = 0);
    string(const string& str);
    string(const span<char>& vec, int length, int offset = 0);
    string(const span<char>& vec);

    operator rostring() const;
    
    constexpr bool operator==(const rostring other) const { return starts_with(other) && size() == other.size(); }
    constexpr bool operator!=(const rostring other) const { return !(*this == other); }

    char* c_str_new();
    char* c_str_this();
};

class ostringstream : public ostream<char> {
public:
    void write_u(uint64_t n, int leading = 0, int radix = 10, char leadChar = ' ', const char* letters = "0123456789ABCDEF");
    void write_i(int64_t n, int leading = 0, int radix = 10, char leadChar = ' ', const char* letters = "0123456789ABCDEF");
    void write_d(double n, int leading = 0, int trailing = 3, char leadChar = ' ');
    void write_bz(const void* dat, int size);

    template <typename T> void write_b(const T dat) {
        write_bz(&dat, sizeof(T));
    }
    template <typename T> void write_bn(const T* dat, int count) {
        for (int i = 0; i < count; i++)
            write_b<T>(dat[i]);
    }
    template <typename T> void write_bv(const span<T> dat, int count) {
        for (int i = 0; i < count; i++)
            write_b<T>(dat.at(i));
    }
    template <typename T> void write(const T dat);
};

class istringstream : public istream<char> {
public:
    istringstream(const rostring s);
    operator rostring() const;

    const rostring read_while(bool(*condition)(rostring));
    const rostring read_until(bool(*condition)(rostring));
    const rostring read_until(char c);
    const rostring read_until_inc(bool(*condition)(rostring));
    const rostring read_until_inc(char c);
    const rostring read_until_any(const rostring any);
    const rostring read_until_any_inc(const rostring any);
    const rostring read_until_any(span<rostring> any);
    void read_bz(void* dat, int size);

    template <typename T> T read();
    template <typename T> T read_b() {
        T ret;
        read_bz(&ret, sizeof(T));
        return ret;
    }
    template <typename T> T* read_bn(int count) {
        T* ret = malloc(sizeof(T) * count);
        for (int i = 0; i < count; i++)
            ret[i] = read_b<T>();
        return ret;
    }
    template <typename T> vector<T> read_bv(int count) {
        vector<T> vec(count);
        for (int i = 0; i < count; i++)
            vec[i] = read_b<T>();
        return vec;
    }
    template <typename T> T read_c() {
        int tmp = idx;
        T ret = read<T>();
        idx = tmp;
        return ret;
    }
    template <typename T> T read_bc() {
        int tmp = idx;
        T ret = read_b<T>();
        idx = tmp;
        return ret;
    }
};

string format(const rostring fmt, ...);
