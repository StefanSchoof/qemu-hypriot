FROM tianon/qemu as builder

RUN apt-get update && apt-get install -y \
    wget \
    p7zip-full \
 && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/hypriot/image-builder-rpi/releases/download/v1.10.0/hypriotos-rpi-v1.10.0.img.zip -O hypriot.zip \
 && 7z x hypriot.zip \
 && 7z x hypriot*.img 0.fat \
 && 7z x 0.fat kernel7.img bcm2709-rpi-2-b.dtb

FROM tianon/qemu

COPY --from=builder kernel7.img bcm2709-rpi-2-b.dtb hypriotos-rpi-v1.10.0.img /

CMD qemu-system-arm \
    -machine raspi2 \
    -kernel kernel7.img \
    -dtb bcm2709-rpi-2-b.dtb \
    -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1" \
    -drive file=hypriotos-rpi-v1.10.0.img,if=sd,format=raw \
    -curses \
    -serial stdio \
    -no-reboot
