.PHONY: run
run: puzzle.iso
	qemu-system-x86_64 -M q35 -m 2G -cdrom puzzle.iso -debugcon stdio -boot d
	make clean

puzzle.iso: kernel get-hyper
	cp hyper.cfg Meta/iso_root
	cp Meta/hyper/hyper_iso_boot Meta/iso_root
	cp Meta/hyper/esp.fat Meta/iso_root
	xorriso -as mkisofs \
	  -b /hyper_iso_boot \
	  -no-emul-boot \
	  -boot-load-size 4 \
	  -boot-info-table \
	  --efi-boot /esp.fat \
	  -efi-boot-part --efi-boot-image \
	  --protective-msdos-label ./Meta/iso_root \
	  -o $@
	./Meta/hyper/hyper_install-linux-x86_64 ./$@

.PHONY: kernel get-hyper clean distclean
kernel:
	mkdir -p Meta/iso_root
	make -C Kernel

get-hyper:
	make -C Meta/hyper

clean:
	make -C Kernel clean

distclean:
	make -C Kernel distclean
	make -C Meta/hyper clean
	rm -rf Meta/iso_root
