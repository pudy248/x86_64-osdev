#pragma once
#include <kstddefs.h>
#include <sys/global.h>
#include <stl/vector.hpp>

class string;

class rostring : public span<char> {
public:
    rostring() = default;
    rostring(rostring&& other) = default;
    rostring& operator=(const rostring& other) = default;
    rostring& operator=(rostring&& other) = default;

    rostring(const char* str, int length, int offset = 0);
    rostring(const char* cstr);
    rostring(const rostring& str, int length, int offset = 0);
    rostring(const rostring& str);
    rostring(const string& str, int length, int offset = 0);
    rostring(const string& str);
    rostring(const span<char>& vec, int length, int offset = 0);
    rostring(const span<char>& vec);

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

    char* c_str_new();
    char* c_str_this();
};

class ostringstream {
public:
    string str;
    ostringstream() = default;

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

string format(const rostring fmt, ...);

class istringstream {
public:
    rostring data;
    int ridx = 0;
    istringstream() = default;
    istringstream(const rostring s);
    istringstream(const string s);
    istringstream(const span<char> s);

    constexpr bool readable() const;
    const rostring read_until(const rostring any);
    const rostring read_until(char c);
    const rostring read_until_inc(const rostring any);
    const rostring read_until_inc(char c);
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
        int tmp = ridx;
        T ret = read<T>();
        ridx = tmp;
        return ret;
    }
    template <typename T> T read_bc() {
        int tmp = ridx;
        T ret = read_b<T>();
        ridx = tmp;
        return ret;
    }
};

#define print(str) globals->vga_console.putstr(str)
#define printf(fmt, ...) globals->vga_console.putstr(format(rostring(fmt, strlen(fmt)), __VA_ARGS__).c_str_this())
