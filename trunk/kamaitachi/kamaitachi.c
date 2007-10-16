#include <assert.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/ptrace.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/uio.h>

#define KERNEL_OFFSET   0xc010378c

struct allocator_data {
    uint32_t total_size; 
    uint32_t allocated_data;
    uint32_t allocated_data_phys;
};

/* These are (offset in kernel, size) pairs. */
struct bootloader_data {
    uint32_t phys_start;        /* 0 */
    uint32_t code;
    uint32_t code_size;         /* 8 */
    uint32_t img;
    uint32_t img_size;          /* 16 */
    uint32_t kernel;            /* 20 */
    uint32_t kernel_size;       /* 24 */
    uint32_t ramdisk;
    uint32_t ramdisk_size;
    uint32_t boot_args;
    uint32_t boot_args_size;
};

extern uint8_t *boot_data, *loader_data, *allocator_data;
extern uint32_t boot_len, loader_code_len, loader_len;
extern uint32_t allocator_code_len, allocator_len;

void inject(int fd, void *data, uint32_t len, uint32_t *kaddr, uint32_t *klen, 
    char *desc)
{
    int32_t written;

    fprintf(stderr, "Injecting %s into kernel... ", desc);
    *kaddr = lseek(fd, 0, SEEK_CUR);
    *klen = len; 

    while (len) {
        if ((written = write(fd, data, len)) <= 0) {
            perror("write failed");
            exit(1);
        }
        data += written;
        len -= written;
        fprintf(stderr, "wrote %d bytes... ", written);
    }

    fprintf(stderr, "%d bytes written ok at $%08x.\n", *klen, *kaddr);
}

int main()
{
    int fd;
    uint8_t *img, *kernel;
    uint32_t img_size, kernel_size, total_size;
    struct allocator_data adata;
    struct bootloader_data data;
    struct stat sb;

    data.ramdisk_size = 0;
    data.boot_args_size = 0;

    fprintf(stderr, "Loading bootloader image... ");
    assert((fd = open(PKGDATADIR "/bootloader-image.tga", O_RDONLY, 0)) >= 0);
    fstat(fd, &sb);
    img = malloc(img_size = sb.st_size); 
    assert(read(fd, img, img_size) == img_size);
    close(fd);
    fprintf(stderr, "%d bytes loaded.\n", (int)(sb.st_size));

    fprintf(stderr, "Loading Linux kernel... ");
    assert((fd = open(PKGDATADIR "/vmlinuz", O_RDONLY, 0)) >= 0);
    fstat(fd, &sb);
    kernel = malloc(kernel_size = sb.st_size); 
    assert(read(fd, kernel, kernel_size) == kernel_size);
    close(fd);
    fprintf(stderr, "%d bytes loaded.\n", (int)(sb.st_size));

    total_size = boot_len + img_size + kernel_size;

    fprintf(stderr, "Injecting allocator (stage 1) stub into kernel... ");
    assert((fd = open("/dev/kmem", O_RDWR, 0)) >= 0);
    assert(lseek(fd, KERNEL_OFFSET, SEEK_SET) == KERNEL_OFFSET);
    assert(write(fd, allocator_data, allocator_len) == allocator_len);
    assert(lseek(fd, KERNEL_OFFSET + allocator_code_len, SEEK_SET) ==
        KERNEL_OFFSET + allocator_code_len);
    assert(write(fd, &total_size, sizeof(uint32_t)) == sizeof(uint32_t)); 
    fprintf(stderr, "%d bytes written ok.\n", allocator_len);

    fprintf(stderr, "Running allocator... ");
    ptrace(PT_ATTACH, 0, 0, 0);     /* runs allocator */
    assert(lseek(fd, KERNEL_OFFSET + allocator_code_len, SEEK_SET) ==
        KERNEL_OFFSET + allocator_code_len);
    assert(read(fd, &adata, sizeof(struct allocator_data)) == sizeof(struct
        allocator_data)); 
    fprintf(stderr, "%d bytes allocated in kernel space at $%08x/%08x ok.\n",
        (int)(adata.total_size), (uint32_t)(adata.allocated_data),
        (uint32_t)(adata.allocated_data_phys));

    data.phys_start = adata.allocated_data_phys;
    assert(lseek(fd, adata.allocated_data, SEEK_SET) == adata.allocated_data);

    inject(fd, boot_data, boot_len, &(data.code), &(data.code_size),
        "bootloader code"); /* code must be first */
    inject(fd, img, img_size, &data.img, &data.img_size, "boot image");
    inject(fd, kernel, kernel_size, &data.kernel, &data.kernel_size,
        "Linux kernel");

    fprintf(stderr, "Injecting loader (stage 2) stub into kernel... ");
    assert((fd = open("/dev/kmem", O_WRONLY, 0)) >= 0);
    assert(lseek(fd, KERNEL_OFFSET, SEEK_SET) == KERNEL_OFFSET);
    assert(write(fd, loader_data, loader_len) == loader_len);
    assert(lseek(fd, KERNEL_OFFSET + loader_code_len, SEEK_SET) ==
        KERNEL_OFFSET + loader_code_len);
    assert(write(fd, &data, sizeof(struct bootloader_data)) ==
        sizeof(struct bootloader_data)); 
    fprintf(stderr, "%d bytes written ok.\n", loader_len);

    FILE *f;
    f = fopen("/tmp/bld", "w");
    fwrite(&data, sizeof(struct bootloader_data), 1, f);
    fclose(f);

    return 0;

    fprintf(stderr, "Starting bootloader at $%08x...\n", (uint32_t)(
        data.code));
    ptrace(PT_ATTACH, 0, 0, 0);

    return 1;
}

