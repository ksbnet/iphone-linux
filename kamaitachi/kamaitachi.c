#include <assert.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/ptrace.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/uio.h>

#define KERNEL_OFFSET   0xc010378c

#define MIN(x,y)        ((x) < (y) ? (x) : (y))

#define THINGY_COUNT            4
#define THINGY_BOOTLOADER_CODE  0
#define THINGY_BOOT_PICTURE     1
#define THINGY_KERNEL           2
#define THINGY_FONT             3

struct allocator_data {
    uint32_t total_size; 
    uint32_t allocated_data;
    uint32_t allocated_data_phys;
};

/* A "thingy" is a piece of data that will be injected into the Darwin kernel
 * and which the bootloader has access to. In order to facilitate this, the
 * bootloader needs to know the thingies' physical addresses, so they are
 * stored here. */
struct thingy {
    uint32_t virt_addr;
    uint32_t phys_addr;
    uint32_t size;
};

struct thingy_info {
    char *path;
    char *name;
};

extern void *boot_data, *allocator_data, *loader_data;
extern uint32_t boot_len, allocator_code_len, allocator_len, loader_len;
extern uint32_t loader_code_len;

const struct thingy_info thingy_info[THINGY_COUNT] = {
    [THINGY_BOOTLOADER_CODE] = { NULL, "the bootloader code" },
    [THINGY_BOOT_PICTURE] = { "bootloader-image.tga" , "the boot picture" },
    [THINGY_KERNEL] = { "vmlinuz", "the Linux kernel" },
    [THINGY_FONT] = { "bootloader-font.tga", "the bootloader font" }
};

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
    char *path;
    int fd, kfd, i;
    uint8_t *ptr, *optr;
    uint32_t total_size = 0, phys_addr, left, written;
    struct allocator_data adata;
    struct stat sb;
    struct thingy thingies[THINGY_COUNT];

    /* Die here rather than crashing in the bootloader if the stride of the
     * thingies array is not unit... */
    assert(sizeof(thingies) == sizeof(struct thingy) * THINGY_COUNT);

    /* Calculate the size of the space that needs to be allocated in the Darwin
     * kernel. */
    for (i = 0; i < THINGY_COUNT; i++) {
        fprintf(stderr, "Calculating size of %s... ", thingy_info[i].name);

        if (thingy_info[i].path) {
            asprintf(&path, "%s%s", PKGDATADIR, thingy_info[i].path);
            assert(!stat(path, &sb));
            free(path);
            thingies[i].size = sb.st_size;
        } else
            thingies[i].size = boot_len;    /* bootloader code */

        total_size += thingies[i].size;

        fprintf(stderr, "%d B.\n", (int)(thingies[i].size));
    }

    fprintf(stderr, "Injecting allocator (stage 1) stub into kernel... ");
    assert((kfd = open("/dev/kmem", O_RDWR, 0)) >= 0);
    assert(lseek(kfd, KERNEL_OFFSET, SEEK_SET) == KERNEL_OFFSET);
    assert(write(kfd, allocator_data, allocator_len) == allocator_len);
    assert(lseek(kfd, KERNEL_OFFSET + allocator_code_len, SEEK_SET) ==
        KERNEL_OFFSET + allocator_code_len);
    assert(write(kfd, &total_size, sizeof(uint32_t)) == sizeof(uint32_t)); 
    fprintf(stderr, "%d bytes written ok.\n", allocator_len);

    fprintf(stderr, "Running allocator... ");
    ptrace(PT_ATTACH, 0, 0, 0);     /* runs allocator */
    assert(lseek(kfd, KERNEL_OFFSET + allocator_code_len, SEEK_SET) ==
        KERNEL_OFFSET + allocator_code_len);
    assert(read(kfd, &adata, sizeof(struct allocator_data)) == sizeof(struct
        allocator_data)); 
    fprintf(stderr, "ok, %d B at 0x%08x v, 0x%08x p.\n",
        (int)(adata.total_size), (uint32_t)(adata.allocated_data),
        (uint32_t)(adata.allocated_data_phys));

    phys_addr = adata.allocated_data_phys;
    assert(lseek(kfd, adata.allocated_data, SEEK_SET) == adata.allocated_data);

    /* Inject all the thingies into the kernel. */
    for (i = 0; i < THINGY_COUNT; i++) {
        fprintf(stderr, "Injecting %s... ", thingy_info[i].name);

        thingies[i].virt_addr = lseek(kfd, 0, SEEK_CUR); 
        thingies[i].phys_addr = phys_addr;

        phys_addr += thingies[i].size;

        if (thingy_info[i].path) {
            asprintf(&path, "%s%s", PKGDATADIR, thingy_info[i].path);
            assert((fd = open(path, O_RDONLY, 0)) >= 0); 
            free(path);
            assert(optr = mmap(NULL, thingies[i].size, PROT_READ, MAP_FILE, fd,
                0));
            ptr = optr;
        } else
            ptr = boot_data;        /* bootloader code */

        left = thingies[i].size;

        while (left) {
            assert((written = write(kfd, ptr, left)) > 0);
            left -= written; ptr += written;
        }

        fprintf(stderr, "ok, %d B at 0x%08x v, 0x%08x p.\n", (int)(
            thingies[i].size), thingies[i].virt_addr, thingies[i].phys_addr);

        if (thingy_info[i].path) {
            munmap((caddr_t)optr, thingies[i].size);
            close(fd);
        }
    }

    fprintf(stderr, "Injecting loader (stage 2) stub into kernel... ");
    assert((fd = open("/dev/kmem", O_WRONLY, 0)) >= 0);
    assert(lseek(fd, KERNEL_OFFSET, SEEK_SET) == KERNEL_OFFSET);
    assert(write(fd, loader_data, loader_len) == loader_len);
    assert(lseek(fd, KERNEL_OFFSET + loader_code_len, SEEK_SET) ==
        KERNEL_OFFSET + loader_code_len);
    assert(write(fd, thingies, sizeof(struct thingy) * THINGY_COUNT) ==
        sizeof(struct thingy) * THINGY_COUNT); 
    fprintf(stderr, "%d bytes written ok.\n", loader_len);

    fprintf(stderr, "Starting bootloader...\n");
    ptrace(PT_ATTACH, 0, 0, 0);

    return 1;
}

