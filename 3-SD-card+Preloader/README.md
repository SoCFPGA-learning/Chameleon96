# SD card / Generate preloader for your LoanIOs
### Table of contents

* Intro 
	* Objectives 
	* Prerequisites 
	* Considerations 
	* Sources of information 
* Partition structure of the original Chameleon96 SD card 
* Backup your original Chameleon96 16 GB SD card 
* Backup the bootloader/u-boot partition (or any particular partition) 
* Restore the SD image into another card to mess with it 
* Generate the preloader / u-boot 
	* Run the BSP editor 
	* Process for u-boot included with EDS versions below 19.1 
	* Process for other u-boot versions and for EDS versions from 19.1 
		* Download u-boot 
		* Run QTS-filter 
		* Compile u-boot 
* Burn the preloader / u-boot into the SD card (to work with loanIOs) 
* Final considerations 


Intro
-----

### Objectives

* Backup your original Chameleon96 16 GB SD card
* Restore the original SD card into another card to mess with it
* Generate the preloader / u-boot
* Burn the preloader / u-boot into the SD card (to work with loanIOs)


### Prerequisites

* Original 16GB SD card from Chameleon96 board
* [Intel SoC EDS](https://fpgasoftware.intel.com/soceds/) (Embedded Development Suite) 


### Considerations
This tutorial has been made with this software setup:

* OS Ubuntu 20.04


### Sources of information

* [Chameleon96 telegram group](https://t.me/Chameleon96)
* [Rætro's docs  to generate the preloader](https://docs.raetro.com/books/arrow-chameleon96/page/overview)
* [github.com/somhi/kameleon96/](https://github.com/somhi/kameleon96)



Partition structure of the original Chameleon96 SD card
-------------------------------------------------------

Let's see how the SD card is partitioned.  In Linux just follow these steps:

* Insert SD card into your SD card reader
* Open a terminal window
* Determine which is your SD device through one of these methods:
	* command 'lsblk'  lists all the devices and identify your just inserted SD card
	* command 'gnome-disks' will launch an IDE where you can select the just inserted SD card and see its device identification
* To see the partition Id launch the following command:  


```
sudo fdisk -l /dev/sdX

#Replace sdX with your own device
#This is an example  output of my 8GB SD card /dev/sdb
#sdb1, sdb2, sdb3 corresponds to the partitions of this device

Disk /dev/sdb: 7,46 GiB, 7994343424 bytes, 15613952 sectors
Disk model: SD  Transcend   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x87d11764

Device    			Start   Final 	Sectors   Size Id  Type
/dev/sdb1            7154892 7574321  419430 204,8M  b W95 FAT32
/dev/sdb2              14336 7144651 7130316   3,4G 83 Linux
/dev/sdb3               2048    4095    2048     1M a2 unknown
```


As we can see in the output above, in the original Chameleon96 SD card there are three partitions:

* FAT32 partition (Id b), which contains three files:
	* zImage (kernel file that loads after uboot)
	* socfpga.dtb (device tree block file which describes the hardware components of the board)
	* cv96.rbf (this is the core that loads into the FPGA when the system boots)
* Linux root file-system partition (Id 83)
* Preloader/U-boot partition (Id a2)


We can recognize the preloader/u-boot partition with the Id **a2** which in my case corresponds to /dev/sdb3


Backup your original Chameleon96 16 GB SD card
----------------------------------------------

If you want to preserve your original Chameleon96 SD card make a backup of it.

In Linux just follow these steps:

* Determine which is your SD device through the methods described above
* Use the 'dd' command to copy the device input (if) to the output file (of)  (rename sd.img as you like)  in blocks of 1MB and we are just going to copy the firsts 3800 blocks as the rest of space in the SD card is not used  


```
sudo dd if=/dev/sdX of=sd.img bs=1M count=3800 

#[Replace sdX with your own device]
```



* Now we are left in the current terminal folder with the file 'sd.img' which is about 4GB long
* Compress the file to save storage space


```
tar zcvf sd.img.tar.gz sd.img
```



Backup the bootloader/u-boot partition (or any particular partition)
--------------------------------------------------------------------

**Note: This step is needed if you want to boot into the Linux distro later on**

You can backup just a particular partition of the SD card.   
For example if you want to just backup the u-boot partition (Id a2) launch:

```
sudo dd if=/dev/sdXY of=sd-uboot.img

#[Replace sdXY with your own device X and partition Y (in my case is /dev/sdb3)]
```



Restore the SD image into another card to mess with it
------------------------------------------------------

You can use whatever size of card you like, but with an SD of a minimum size of 4GB is enough.

In Linux just follow these steps:

* Determine which is your SD device through the methods described above  


**NOTE:  FOLLOWING STEP COULD POTENTIALLY DESTROY DATA IN YOUR SYSTEM IF NOT USED CORRECTLY. YOU ARE RESPONSIBLE TO SELECT THE RIGHT DEVICE AND PARTITION WHERE TO RESTORE YOUR IMAGE.**


* Decompress the backup image and use the 'dd' command to copy the image input file (if) to the output device (of) in blocks of 1MB  


```
tar zxvf sd.img.tar.gz
sudo dd if=sd.img of=/dev/sdX bs=1M

#[Replace sdX with your own device]
```


* Alternatively you can directly restore the image from a tar compressed file with this command:  

 
```
tar zxvfO sd.img.tar.gz | sudo dd of=/dev/sdX bs=1M
```

(use of this tar command can be seen [here](https://wilt.isaac.su/articles/how-to-write-a-disk-image-directly-from-targz-using-tar-and-dd)).

Generate the preloader / u-boot
-------------------------------

After generating in the previous tutorial the Qsys HDL and compiling successfully your project, Quartus generates an hps_isw_handoff folder with the required settings data to generate the preloader with your loanIOs configured.

### Run the BSP editor

Run the BSP editor from the Intel FPGA Embedded Command Shell ([Intel SoC EDS](https://fpgasoftware.intel.com/soceds/) installation is required)

First launch a terminal in the Quartus project folder and load the embedded shell of EDS:

```
/your-install-folder-full-path/intelFPGA_lite/20.1/embedded/embedded_command_shell.sh

# modify according to your EDS installation folder and EDS version 17.1, 20.1, ...
```


Then run the BSP editor:

```
bsp-editor
```


* Select File->New BSP and select the following:
	* Preloader settings directory > click the ... button then navigate to and select the folder inside the hps_isw_handoff folder
	* Leave the other settings at their defaults.
* The next window allows you to customize the preloader settings. Leave default settings.
* Click Generate. The BSP editor will create a software/spl_bsp folder to build the preloader in. 
* Exit the program.


### Process for u-boot included with EDS versions below 19.1

Note: Following steps should be valid for SoC EDS Standard versions below 19.1.
Note: If we want to use another version of u-boot jump to the next point.


* You can now cd to the newly created folder inside the Quartus project main folder and make the preloader.


```
cd software/spl_bsp/
make
```


You should be left with a **preloader-mkpimage.bin** file, which is actually multiple copies of the preloader concatenated together, ready to be burned to your boot media (see below).

### Process for other u-boot versions and for EDS versions from 19.1

Note: this steps are also valid for Quartus/EDS 17.1 if we want to use another u-boot version.

After running the BSP editor follow these steps:

* Download u-boot 
* Run the QTS-filter command 
* Compile u-boot 


#### Download u-boot

You can choose the u-boot version of your like (e.g. [u-boot Raetro](https://github.com/Raetro/u-boot_Raetro) when it will be publicly available).

Here we will clone the latest u-boot from Altera's github. 

Open a terminal in the folder you want to store the u-boot and launch:

```
git clone https://github.com/altera-opensource/u-boot-socfpga
```


#### Run QTS-filter

QTS-filter will process the files generated by Quartus in the previous steps and will convert and store them in the corresponding u-boot folder we will compile later. More details about this process can be found [here](https://github.com/altera-opensource/u-boot-socfpga/blob/socfpga_v2020.04/doc/README.socfpga).

Open a terminal window in the u-boot folder, and launch the qts-filter program. 

```
$ ./arch/arm/mach-socfpga/qts-filter.sh \
		<soc_type> \
		<input_qts_dir> \
		<input_bsp_dir> \
		<output_dir>
		
# qts-filter process QTS-generated files into U-Boot compatible ones.
#	soc_type      - Type of SoC, either 'cyclone5' or 'arria5'.
#	input_qts_dir - Directory with compiled Quartus project and containing the Quartus project file (QPF).
#	input_bsp_dir - Directory with generated bsp containing the settings.bsp file.
#	output_dir    - Directory to store the U-Boot compatible headers.
```


This is a real example:

```
cd u-boot-socfpga
./arch/arm/mach-socfpga/qts-filter.sh  \
	cyclone5  \
	/home/username/Coding/chameleon96/3.blink-loanio-LS_connector \
	/home/username/Coding/chameleon96/3.blink-loanio-LS_connector/software/spl_bsp \
	./board/altera/cyclone5-socdk/qts 

```


#### Compile u-boot

Here we will compile the latest u-boot from Altera's github.

Run the following commands (just needed the first time you compile): 

```
#cd to-your-own-folder  (in my case ~/bin)
cd ~/bin
#download gcc version needed to compile u-boot in the the Chameleon96 board
wget https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz
#extract its content
tar xf gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz
#install dependencies required for compiling
sudo apt-get install build-essential bc liblz4-tool device-tree-compiler wget libncurses5-dev libncursesw5-dev bison flex libssl-dev

```


Thereafter, every time you want to compile, you need to export following variables in a terminal:

```
export PATH=~/bin/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin:$PATH
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
```


Then go into your u-boot folder and compile it:

```
cd u-boot-socfpga/
make socfpga_cyclone5_defconfig
make -j$(nproc)
```


You should be left with a **u-boot-with-spl.sfp** file, ready to be burned to your SD card (see below).

More information about this process can be found [here.](https://rocketboards.org/foswiki/Documentation/BuildingBootloader)


Burn the preloader / u-boot into the SD card (to work with loanIOs)
-------------------------------------------------------------------

Once you've got a preloader image (like preloader-mkpimage.bin) or an u-boot image (like u-boot-with-spl.sfp) it's time to burn it into the SD card.

Follow these steps to replace the preloader / u-boot in your SD card:

* Determine which is your SD device through the methods described above  


**NOTE:  FOLLOWING STEP COULD POTENTIALLY DESTROY DATA IN YOUR SYSTEM IF NOT USED CORRECTLY. YOU ARE RESPONSIBLE TO SELECT THE RIGHT DEVICE AND PARTITION WHERE TO RESTORE YOUR IMAGE.**


* Use the 'dd' command to replace the image input file (if) into the output device (of) 


```
sudo dd if=u-boot-with-spl.sfp of=/dev/sdXY  

#[Replace u-boot-with-spl.sfp with your preloader/u-boot filename]
#[Replace sdXY with your own device X and partition Y]
```


Final considerations
--------------------

* AFTER BURNING THE PRELOADER / UBOOT:
	* YOU CAN PROGRAM THE FPGA CORE AND IT SHOULD RUN OK
	* LINUX WILL NOT BOOT (IN ORDER TO RUN LINUX AGAIN JUST BURN THE ORIGINAL PRELOADER)
	* IF YOU CONNECT THROUGH SERIAL COMMS TO THE BOARD YOU WILL SEE THAT U-BOOT GIVES AN ERROR RELATED TO MEMORY CONFIGURATION. THIS IS NORMAL AS WE HAVEN'T CONFIGURED YET THE MEMORY SETTINGS IN THE HPS PROPERTIES.



 

