C:\ARM\aarch64-elf\gcc-linaro-7.2.1-2017.11-i686-mingw32_aarch64-elf\bin\aarch64-elf-g++ baremetal/aemv8a/pagetables.s -o baremetal/aemv8a/pagetables.o -c -specs=nosys.specs -g

C:\ARM\aarch64-elf\gcc-linaro-7.2.1-2017.11-i686-mingw32_aarch64-elf\bin\aarch64-elf-g++ -c baremetal/aemv8a/neon_cnn_baremetal.cpp -o baremetal/aemv8a/neon_cnn_baremetal.o -march=armv8-a -I. -Iinclude -std=c++11 -larm_compute-static -larm_compute-core-static  -Lbuild  -fPIC -DNO_MULTI_THREADING -DBARE_METAL -specs=nosys.specs -g

C:\ARM\aarch64-elf\gcc-linaro-7.2.1-2017.11-i686-mingw32_aarch64-elf\bin\aarch64-elf-g++ baremetal/aemv8a/vectors.s  -o baremetal/aemv8a/vectors.o -c -specs=nosys.specs -g

C:\ARM\aarch64-elf\gcc-linaro-7.2.1-2017.11-i686-mingw32_aarch64-elf\bin\aarch64-elf-g++ baremetal/aemv8a/bootcode.s -o baremetal/aemv8a/bootcode.o -c -specs=nosys.specs -g

C:\ARM\aarch64-elf\gcc-linaro-7.2.1-2017.11-i686-mingw32_aarch64-elf\bin\aarch64-elf-g++ -c baremetal/aemv8a/output_trickbox.c -o baremetal/aemv8a/output_trickbox.o -specs=nosys.specs -g

C:\ARM\aarch64-elf\gcc-linaro-7.2.1-2017.11-i686-mingw32_aarch64-elf\bin\aarch64-elf-g++ -c baremetal/aemv8a/retarget-gcc.c -o baremetal/aemv8a/retarget-gcc.o -specs=nosys.specs -g

C:\ARM\aarch64-elf\gcc-linaro-7.2.1-2017.11-i686-mingw32_aarch64-elf\bin\aarch64-elf-g++ baremetal/aemv8a/stackheap.s -o baremetal/aemv8a/stackheap.o -c -specs=nosys.specs -g

C:\ARM\aarch64-elf\gcc-linaro-7.2.1-2017.11-i686-mingw32_aarch64-elf\bin\aarch64-elf-g++ baremetal/aemv8a/vectors.o baremetal/aemv8a/stackheap.o baremetal/aemv8a/retarget-gcc.o baremetal/aemv8a/pagetables.o baremetal/aemv8a/output_trickbox.o baremetal/aemv8a/neon_cnn_baremetal.o baremetal/aemv8a/bootcode.o -o baremetal/aemv8a/neon_cnn_bm_example.elf -I. -Lbuild -larm_compute-static -larm_compute_core-static -T baremetal/aemv8a/link_csrc_aarch64.ld -march=armv8-a -specs=nosys.specs -fstack-protector -g
