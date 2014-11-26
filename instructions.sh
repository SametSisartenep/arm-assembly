# DEVELOPMENT INSTRUCTIONS FOR ARM With QEMU
# 
# Resources: http://www.bravegnu.org/gnu-eprog/index.html
#
# Building the Binary
arm-none-eabi-as -o <file_name>.o <file_name>.s

arm-none-eabi-ld -Ttext=0x0 -o <file_name>.elf <file_name>.o

# To view the address assignment for various labels
arm-none-eabi-nm <file_name>.elf

# To convert between different object file formats
# objcopy -O <output-format> <in-file> <out-file>
arm-none-eabi-objcopy -O binary <file_name>.elf <file_name>.bin

# Executing in Qemu
# When the ARM processor is reset, it starts executing from address 0x0. On the connex board a 16MB Flash is located at address 0x0. The instructions present in the beginning of the Flash will be executed.
#
# When qemu emulates the connex board, a file has to be specified which will be treated file as Flash memory. The Flash file format is very simple. To get the byte from address X in the Flash, qemu reads the byte from offset X in the file. In fact, this is the same as the binary file format.
#
# To test the program, on the emulated Gumstix connex board, we first create a 16MB file representing the Flash. We use the dd command to copy 16MB of zeroes from /dev/zero to the file flash.bin. The data is copied in 4K blocks.
dd if=/dev/zero of=flash.bin bs=4096 count=4096

# add.bin file is then copied into the beginning of the Flash
dd if=<file_name>.bin of=flash.bin bs=4096 conv=notrunc

# After reset, the processor will start executing from address 0x0, and the instructions from the program will get executed. Let's invoke qemu!
qemu-system-arm -M connex -pflash flash.bin -nographic -serial /dev/null

# Inside QEMU
# To view the contents of the registers
(qemu) info registers

# Quitting
(qemu) quit

# Physical memory dump from <addr>
# f -> number of data items to be dumped
# m -> size of each data item (in bits). {b:8, h:16, w:32, g:64}
# t -> display format. {x:hex, d:dec, u:unsig_dec, o:octal, c:char, i:assembly}
(qemu) xp /fmt addr

# Reset the system
(qemu) system_reset
