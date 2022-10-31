HYPER_VERSION=0.4.0

.PHONY: get-hyper clean all

all: get-hyper esp.fat

get-hyper: BOOTX64.EFI hyper_install-linux-x86_64 hyper_iso_boot

esp.fat: get-hyper
	dd if=/dev/zero of=esp.fat bs=1024 count=100
	mkfs.vfat esp.fat
	mkdir -p tmp_mnt
	sudo mount -o loop esp.fat ./tmp_mnt
	sudo mkdir ./tmp_mnt/EFI
	sudo mkdir ./tmp_mnt/EFI/BOOT
	sudo cp ./BOOTX64.EFI ./tmp_mnt/EFI/BOOT
	sudo umount ./tmp_mnt
	rmdir ./tmp_mnt

clean:
	rm -rf BOOTX64.EFI hyper_install-linux-x86_64 hyper_iso_boot esp.fat

BOOTX64.EFI:
	wget https://github.com/UltraOS/Hyper/releases/download/v${HYPER_VERSION}/BOOTX64.EFI

hyper_install-linux-x86_64:
	wget https://github.com/UltraOS/Hyper/releases/download/v${HYPER_VERSION}/hyper_install-linux-x86_64
	chmod +x $@

hyper_iso_boot:
	wget https://github.com/UltraOS/Hyper/releases/download/v${HYPER_VERSION}/hyper_iso_boot

