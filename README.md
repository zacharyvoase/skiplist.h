skiplist.h
==========

Single-header-file, public domain, type-generic C89 skip list implementation.
-----------------------------------------------------------------------------

Implements a sorted dictionary or set with a skiplist. Duplicate elements (i.e.
a sorted linked list) are not currently supported.

1. Download [skiplist.h](https://raw.githubusercontent.com/zacharyvoase/skiplist.h/master/skiplist.h).
   That's the only file you need.
2. Create a guarded header that defines SKIPLIST_KEY and SKIPLIST_VALUE
   and includes skiplist.h. Optionally define SKIPLIST_NAMESPACE.
   Define SKIPLIST_IMPLEMENTATION somewhere in your program above
   your custom header include.
3. Repeat for any different key/value pair types you need. Be sure to
   define different SKIPLIST_NAMESPACE values and define SKIPLIST_IMPLEMENTATION
   once for each key/value type pair.

Other options:

 - SKIPLIST_MAX_LEVELS - 33 by default.
 - SKIPLIST_MALLOC & SKIPLIST_FREE - wrappers for stdlib malloc/free by default.
   Both are passed a void \* data pointer (for memory pool, gc context, etc).
 - SKIPLIST_HEIGHT - a macro function taking `(SKIPLIST_KEY)` which should
   produce an unsigned int 0 <= height < SKIPLIST_MAX_LEVELS. By default this
   is implemented using `arc4random_uniform` in the C standard library, but you
   might want to replace it with a key-dependent function.
 - SKIPLIST_STATIC - if defined, declare all public functions static
   (make skiplist local to the file it's included from).
 - SKIPLIST_EXTERN - 'extern' by default; define to change calling convention
   or linkage etc.

skiplist.h has no dependencies. By default it uses some functions from the C
standard library, but that dependency can be replaced by defining the
SKIPLIST_MALLOC, SKIPLIST_FREE, and SKIPLIST_HEIGHT macros.

Tests
-----

Clone this repository and run `make`. The default Makefile builds and runs
the test suite.

Documentation
-------------

The documentation is built with [cldoc](https://github.com/jessevdk/cldoc) and
should be viewed in a web browser. To build the doc yourself, install cldoc and
run `make doc` from this repository's root.

Example Usage
-------------

```c
/* skiplist_str_int.h */
/* This header should be guarded, as below */
#ifndef SKIPLIST_STR_INT_H
#define SKIPLIST_STR_INT_H

#define SKIPLIST_KEY const char *
#define SKIPLIST_VALUE int
#define SKIPLIST_NAMESPACE sl_strint_
#include "skiplist.h"

#endif

/* program.c */
#include <assert.h>
#include <stdio.h>
#include <string.h>
/* You should only define this once. If it helps,
   you can simply make a skiplist_str_int.c file
   with the following 2 lines and link to it. */
#define SKIPLIST_IMPLEMENTATION
#include "skiplist_str_int.h"

int cmp(const char *a, const char *b, void *userdata) {
    return strcmp(a, b);
}

int iter(const char *key, int val, void *userdata) {
    printf("%s = %d\n", key, val);
    return 0;
}

int main(int argc, const char **argv) {
    sl_strint_skiplist list;
    int err = sl_strint_init(&list, cmp, NULL, NULL);
    assert(err == 0);

    sl_strint_insert(&list, "a", 1, NULL);
    sl_strint_insert(&list, "c", 3, NULL);
    sl_strint_insert(&list, "b", 2, NULL);

    short has_b = sl_strint_find(&list, "b", NULL),  // => 1
          has_d = sl_strint_find(&list, "d", NULL);  // => 0

    int a_val;
    short exists = sl_strint_find(&list, "a", &a_val);
    if (exists)
        printf("a = %d\n", a_val);
    else
        puts("a does not exist");

    int default_val = 10;
    int d_val = sl_strint_get(&list, "d", default_val);  // => 10

    sl_strint_iter(&list, iter, NULL);
    // Prints a = 1, b = 2, c = 3

    int b_val;
    short existed = sl_strint_remove(&list, "b", &b_val);
    if (existed)
        print("b used to be %d, but now it is no more\n", b_val);
    else
        puts("b was only an illusion, a fleeting glimpse of a dream");

    sl_strint_free(&list);
    return 0;
}
```


Unlicense
---------

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or distribute this
software, either in source code form or as a compiled binary, for any purpose,
commercial or non-commercial, and by any means.

In jurisdictions that recognize copyright laws, the author or authors of this
software dedicate any and all copyright interest in the software to the public
domain. We make this dedication for the benefit of the public at large and to
the detriment of our heirs and successors. We intend this dedication to be an
overt act of relinquishment in perpetuity of all present and future rights to
this software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>
