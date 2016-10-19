PRJ_NAME	= midievents
CC			= cc
INC			= `pkg-config --cflags glib-2.0`
LDFLAGS		= -lsmf
BINDIR		=  ../../bin/
BINFILE		= $(BINDIR)$(PRJ_NAME)

all: $(BINFILE)

$(BINFILE): main.c
	mkdir -p $(BINDIR)
	$(CC) $(INC) $(LDFLAGS) $< -o $(BINFILE)

clean:
	rm -f $(BINFILE)
