#pragma once
#include <kstdio.hpp>

class very_verbose_class {
public:
    int id;
    very_verbose_class() : id(0) {
        printf("Default-constructing with id %i at %p.\n", id, this);
    }
    very_verbose_class(int id) : id(id) {
        printf("Constructing new instance with id %i at %p.\n", id, this);
    }
    very_verbose_class(const very_verbose_class& copy) : id(copy.id) {
        printf("Copy-constructing with id %i at %p (from %p).\n", id, this, &copy);
    }
    very_verbose_class(very_verbose_class&& other) : id(other.id) {
        other.id = 0;
        printf("Move-constructing with id %i at %p (from %p).\n", id, this, &other);
    }
    very_verbose_class& operator=(const very_verbose_class& copy) {
        id = copy.id;
        printf("Copy-assigning with id %i at %p (from %p).\n", id, this, &copy);
        return *this;
    }
    very_verbose_class& operator=(very_verbose_class&& other) {
        id = other.id;
        other.id = 0;
        printf("Move-assigning with id %i at %p (from %p).\n", id, this, &other);
        return *this;
    }
    ~very_verbose_class() {
        printf("Destructing with id %i at %p.\n", id, this);
    }
};