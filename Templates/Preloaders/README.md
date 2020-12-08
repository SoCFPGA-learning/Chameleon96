# Preloaders for Chameleon96 board

See below how to burn the preloaders into the SD card.

This folder contains the following preloaders:

* preloader-mkpimage-0.bin
  * Peripheral Pins: enabled SD and UART0
    * Mux table: LoanIOs enabled (14,17,19,22,23,25,27,28,29,30,32,33,34)
  * HPS Clocks: enabled HPS-to-FPGA user 0 clock (100 MHz)
  * SDRAM chameleon96 presets loaded



### How to burn the preloader into the SD card 

Once you've got a preloader image (like preloader-mkpimage.bin) or an u-boot image (like u-boot-with-spl.sfp) it's time to burn it into the SD card.

**Linux instructions**:

Follow these steps to replace the preloader / u-boot in your SD card:

* Determine which is your SD device **sdX** where X can be a, b, c, ...  through one of these methods:
  * command `lsblk`  lists all the devices and identify your just inserted SD card
  * command `gnome-disks` will launch an IDE where you can select the just inserted SD card and see its device identification
* Determine which is your preloader/u-boot partition (Id **a2**). To see the partition Id run the following command `sudo fdisk -l /dev/sdX`

NOTE:  FOLLOWING STEP COULD POTENTIALLY DESTROY DATA IN YOUR SYSTEM IF NOT USED CORRECTLY. YOU ARE RESPONSIBLE TO SELECT THE RIGHT DEVICE AND PARTITION WHERE TO RESTORE YOUR IMAGE.

* Use the `dd` command in the folder you have the preloader binary to replace the image input file (if) into the output device (of) 

`sudo dd if=preloader-mkpimage.bin of=/dev/sdXY`

[Replace preloader-mkpimage.bin with your preloader/u-boot filename]  
[Replace sdXY with your particular device X and partition Y]