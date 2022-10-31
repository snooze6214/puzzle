#include <stdint.h>
#include <ultra_protocol.h>

inline void outb(uint16_t port, uint8_t data) {
    __asm__ volatile("outb %0, %1" :: "a"(data), "Nd"(port));
}

void kernel_entry(struct ultra_boot_context *ctx, uint32_t magic)
{
    char* hw = "hello world";
    for (int i = 0; i < 11; i++)
        outb(0xe9, hw[i]);
}
