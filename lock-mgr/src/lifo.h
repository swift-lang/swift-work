
#pragma once

#include <stdbool.h>

struct lifo
{
  int head;
  int tail;
  int size;
  int capacity;
  int* A;
};

bool lifo_init(struct lifo* L, int capacity);

bool lifo_push(struct lifo* L, int value);

bool lifo_pop(struct lifo* L, int* value);

void lifo_free(struct lifo* L);
