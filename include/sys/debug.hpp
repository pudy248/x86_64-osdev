#pragma once
#include <kstdio.hpp>

class very_verbose_class {
public:
    int id;
    very_verbose_class() : id(0) {
        qprintf<60>("Default-constructing with id %i at %p.\n", id, this);
    }
    very_verbose_class(int id) : id(id) {
        qprintf<60>("Constructing new instance with id %i at %p.\n", id, this);
    }
    very_verbose_class(const very_verbose_class& copy) : id(copy.id) {
        qprintf<60>("Copy-constructing with id %i at %p (from %p).\n", id, this, &copy);
    }
    very_verbose_class(very_verbose_class&& other) : id(other.id) {
        other.id = 0;
        qprintf<60>("Move-constructing with id %i at %p (from %p).\n", id, this, &other);
    }
    very_verbose_class& operator=(const very_verbose_class& copy) {
        id = copy.id;
        qprintf<60>("Copy-assigning with id %i at %p (from %p).\n", id, this, &copy);
        return *this;
    }
    very_verbose_class& operator=(very_verbose_class&& other) {
        id = other.id;
        other.id = 0;
        qprintf<60>("Move-assigning with id %i at %p (from %p).\n", id, this, &other);
        return *this;
    }
    ~very_verbose_class() {
        qprintf<60>("Destructing with id %i at %p.\n", id, this);
    }
};