/*-----------------------------------------------------------------------------
 * The confidential and proprietary information contained in this file may
 * only be used by a person authorised under and to the extent permitted
 * by a subsisting licensing agreement from ARM Limited.
 *
 *            (C) COPYRIGHT 2013 ARM Limited.
 *                ALL RIGHTS RESERVED
 *
 * This entire notice must be reproduced on all copies of this file
 * and copies of this file may only be made by a person if such person is
 * permitted to do so under the terms of a subsisting license agreement
 * from ARM Limited.
 *
 *      SVN Information
 *
 *      Checked In          : $Date: 2013-03-11 17:54:35 +0000 (Mon, 11 Mar 2013) $
 *
 *      Revision            : $Revision: 240933 $
 *
 *      Release Information : CORTEXA53-r0p0-00bet2
 *
 *-----------------------------------------------------------------------------
 */

ENTRY(bootcode)

SECTIONS
{
  . = 0x80000000;

  /* Code starts with bootcode, then the vector table, then the
   * remainder of the code */
  .text :
  {
    *bootcode.o(boot)
    *vectors.o(vectors)
    *(.text) /* remainder of code */
  } =0

  /* Data */
   __data_start = .;
  .data  : { *(.data)  }
  .data1 : { *(.data1) }

  /* Notes section
   * This is not used so we discard it. Although not used it needs to be
   * explicitly mentioned in the linker script as some toolchains will place
   * the notes section at adderss 0 if it is not explicitly mentioned. */
  /DISCARD/ : { *(.note*) }

  /* Uninitialized data */
  __bss_start   = .;
  __bss_start__ = .;
  .bss   : { *(.bss)   }
  __bss_end   = .;
  __bss_end__ = .;

  . = ALIGN(4);
  __end   = .;
  __end__ = .;
}

