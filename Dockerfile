FROM tianon/qemu

RUN apt-get update && apt-get install -y wget && \
    wget https://github.com/hypriot/image-builder-rpi/releases/download/v1.10.0/hypriotos-rpi-v1.10.0.img.zip -O hypriot.zip

RUN apt-get update && apt-get install unzip
RUN unzip hypriot.zip
RUN apt-get install -y p7zip-full
RUN 7z x hypriot*.img
RUN 7z x 0.fat
CMD qemu-system-arm \
    -machine raspi2 \
    -m 256 \
    -cpu arm1176 \
    -kernel kernel7.img \
    -dtb bcm2709-rpi-2-b.dtb \
    -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1" \
#    -append "rw console=ttyAMA0 root=/dev/sda2 rootfstype=ext4 loglevel=8 rootwait fsck.repair=yes memtest=1" \
#    -drive file=hypriotos-rpi-v1.10.0.img,format=raw \
#    -sd hypriotos-rpi-v1.10.0.img \
#    -sd 1.img \
    -drive file=hypriotos-rpi-v1.10.0.img,if=sd,format=raw \
#    -drive file=1.img,if=sd,format=raw \
    -curses -serial stdio 
