CFLAGS=-DDEBUG -g -O -std=c99 -Wall -Wextra -pedantic

SL_HEADER=skiplist.h
SRCS=test/test_skiplist.c test/ptest.c
OBJS=$(SRCS:.c=.o)
TEST_OUT=test_skiplist

all: build test

build: $(SL_HEADER) $(SRCS) $(TEST_OUT)

.PHONY: test
test: $(TEST_OUT)
	./$(TEST_OUT)


$(TEST_OUT): $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $@

$(OBJS): $(SL_HEADER)

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm test/*.o $(TEST_OUT)
