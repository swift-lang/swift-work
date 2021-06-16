
#include "lifo.h"

bool
lifo_init(struct lifo* L, int capacity)
{
  L->A = malloc(size * sizeof(int));
  L->head = 0;
  L->tail = 0;
  L->size = 0;
  L->capacity = capacity;
}

bool
lifo_push(struct lifo* L, int value)
{
  if (size == capacity - 1)
    return false;
  L->A[L->tail] = value;
  L->tail = (L->tail+1) % L->size;
  L->size++;
  return true;
}

bool
lifo_pop(struct lifo* L, int* value)
{
  if (size == 0)
    return false;
  *value = L->A[L->head];
  L->head = (L->head+1) % L->size;
  L->size--;
  return true;
}

void
lifo_free(struct lifo* L)
{
  free(L->A);
  free(L);
}
