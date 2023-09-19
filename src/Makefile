PROJECT_NAME ?= ngdlp
OUTPUT ?= ./output
FLAGS := -gcflags=all="-N -l"
.PHONY: all dep build clean lib
all: build

lib:
	@go build -o libdlp.so -buildmode=c-shared dlp.go
