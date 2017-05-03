ifdef COVERAGE
CFLAGS=-DDEBUG -g -O -std=c99 -Wall -Wextra -pedantic -fprofile-instr-generate=test_skiplist.profraw -fcoverage-mapping
LDFLAGS=-fprofile-instr-generate=test_skiplist.profraw
else
CFLAGS=-DDEBUG -g -O -std=c99 -Wall -Wextra -pedantic
endif

ifeq ($(shell uname -s),Darwin)
LLVM_PREFIX=xcrun
endif

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

ifdef COVERAGE
skiplist.coverage.html: $(TEST_OUT) test_skiplist.profdata
	$(LLVM_PREFIX) llvm-cov show $(TEST_OUT) \
		-format=html \
		-show-line-counts-or-regions \
		-instr-profile=test_skiplist.profdata \
		$(SL_HEADER) > $@

test_skiplist.profraw: $(TEST_OUT)
	./$(TEST_OUT)

test_skiplist.profdata: test_skiplist.profraw
	$(LLVM_PREFIX) llvm-profdata merge $^ -output $@
endif

.PHONY: clean
clean:
	rm -f test/*.o $(TEST_OUT) *.profdata *.profraw skiplist.coverage.html
