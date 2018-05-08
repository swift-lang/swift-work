
LDFLAGS = -craympich-dpm

all: comm-spawn.x child.x

comm-spawn.x: main.c
	$(CC) $(LDFLAGS) -o $(@) $(<)

child.x: child.c
	$(CC) $(LDFLAGS) -o $(@) $(<)

clean:
	rm -fv *.x *.o
