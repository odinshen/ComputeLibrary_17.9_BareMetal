//------------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//            (C) COPYRIGHT 2010-2016 ARM Limited or its affiliates.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited or its affiliates.
//
//            Release Information : CORINTH-MP090-dev-20160525
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Description:
//   Library re-target file for C-based test code
//------------------------------------------------------------------------------

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/time.h>
#include <sys/times.h>
#include <sys/stat.h>
#include <unistd.h>

extern char __bss_start__[], __bss_end__[];
extern "C" void __libc_init_array(void);
extern "C" void __libc_fini_array(void);

//extern "C" void output_char(unsigned char ch);
extern "C" void initialise_monitor_handles(void) { }

extern "C" int _close(int fh) { }
extern "C" int _gettimeofday(struct timeval* tv,void* tz) { }
extern "C" int _isatty(int fh) { }
extern "C" int _lseek(int fh, off_t offset, int whence) { }
extern "C" int _open(const char *path, int oflag, /* int mode */...) { return 1; }
extern "C" int _read(int fh, unsigned char *buffer, int count) { }
extern "C" int _rename(const char *old, const char *new_ ) { }
extern "C" clock_t _times(struct tms *buf) { }
extern "C" int _unlink(const char *name) { }
extern "C" int _kill(int pid, int sig) { }
extern "C" int _fstat(int fildes, struct stat *buf) { }
extern "C" int _getpid();





extern "C" int _getpid()
{
 return 1;
}


// Redirect output (from printf etc) to the tube.
// This redirects all streams to the tube.
extern "C" int _write(int fh, char *buf, int count)
{
  int i = 0;

  while (i < count)
  //  output_char(buf[i++]);

  return count;
}

// On exit write CTRL-D (EOT character) to the validation tube
// which causes the simulation to terminate
extern "C"  void _exit(int c)
{
 //  output_char('\x04');  // CTRL-D (EOT)

  // Loop forever until the simulator terminates
  while (1);
}

extern "C" caddr_t _sbrk_r ( struct _reent *r, int incr )
{
    extern   unsigned char  bottom_of_heap asm ("heap_base");
    register unsigned char* stack_pointer  asm ("sp");

    static unsigned char *heap_end;
    unsigned char        *prev_heap_end;

    if (heap_end == NULL)
        heap_end = &bottom_of_heap;

    prev_heap_end = heap_end;

    if (heap_end + incr > stack_pointer) {
        r->_errno = ENOMEM;

        return (caddr_t) -1;
    }

    heap_end += incr;

    return (caddr_t) prev_heap_end;
}


void init_libc(void)
{
    // Zero the BSS
    size_t bss_size = __bss_end__ - __bss_start__;
    memset(__bss_start__, 0, bss_size);
    atexit(__libc_fini_array);
    __libc_init_array();
}

extern int main(int argc, char **argv);

extern "C" int _arm_start()
{
//  atexit(__libc_fini_array);
// asm("bl __libc_init_array");
// asm("bl main");
    init_libc();
    exit(main(0, NULL));
}
