#CFLAGS ?= -Wall -Wextra -Werror -g -lm

LDLIBS?= -lm

INCLUDE_PATH = ./src

TARGET   = main

SRCDIR   = src
OBJDIR   = obj
BINDIR   = bin

SOURCES  := $(wildcard $(SRCDIR)/*.cpp)
INCLUDES := $(wildcard $(INCLUDE_PATH)/*.h)
OBJECTS  := $(SOURCES:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)

$(BINDIR)/$(TARGET): $(OBJECTS)
	mkdir -p $(BINDIR)
	g++ -o $@ $^ $(CFLAGS) $(LDLIBS)
	@echo "Linking complete!"

$(OBJECTS): $(OBJDIR)/%.o : $(SRCDIR)/%.cpp
	mkdir -p $(OBJDIR)
	g++ -o $@ -c $< $(CFLAGS) -I$(INCLUDE_PATH)


.PHONY: clean cov
clean:
	rm -f $(OBJDIR)/*.o
	rm -f $(OBJDIR)/*.gcda
	rm -f $(OBJDIR)/*.gcno
	rm -f $(BINDIR)/$(TARGET)
	rm -f $(INCLUDE_PATH)/*.h.gch
	rm -r $(OBJDIR)

all: $(BINDIR)/$(TARGET)
