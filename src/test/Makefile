# 编译器
CC = gcc
# 编译选项
CFLAGS = -Wall -Wextra 
LDFLAGS = -L../ -ldlp
# 目标文件夹
BUILD_DIR = build
# 可执行文件名
TARGET = test
# 静态库文件名
STATIC_LIBRARY = libmylib.a
STATIC_LIBS_DIR = ./lib/
STATIC_LIBS := $(wildcard $(STATIC_LIBS_DIR)/*.a)

SRCS := $(wildcard *.cpp) $(wildcard *.c)
# 获取所有的头文件
HDRS := $(wildcard *.h) $(wildcard *.hpp)
# 生成所有的依赖的对象文件
OBJS := $(addprefix $(BUILD_DIR)/, $(SRCS:.c=.o))

# 所有依赖的对象文件
OBJS = $(addprefix $(BUILD_DIR)/, $(SRCS:.c=.o))

# 默认目标
all: $(TARGET)

# 生成可执行文件
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $(TARGET)


# 生成对象文件
$(BUILD_DIR)/%.o: %.c $(HDRS)
	mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# 清理目标文件和可执行文件
clean:
	rm -rf $(BUILD_DIR) $(TARGET) $(LIBRARY)
