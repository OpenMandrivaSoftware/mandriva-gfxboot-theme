NAME=mandriva-gfxboot-theme
PACKAGE=mandriva-gfxboot-theme
VERSION := 0.23

BINDIR      := /usr/sbin/

PRODUCT      = "Mandriva Linux 2008"
export PRODUCT

HELP2TXT     = $(BINDIR)/help2txt
MKBOOTMSG    = $(BINDIR)/mkbootmsg
BFLAGS       = -O -v -L ../..
INCLUDES     = $(wildcard *.inc)
TRANSLATIONS = $(addsuffix .tr,en $(notdir $(basename $(wildcard po/*.po))))
HELPBOOT     = $(addsuffix .hlp,$(addprefix boot/,$(subst .,,$(suffix $(basename $(wildcard help-boot.*.html))))))
HELPINST     := $(addsuffix .hlp,$(addprefix inst/,$(subst .,,$(suffix $(basename $(wildcard help-install.*.html))))))

HELPBOOT_ALL = $(notdir $(HELPBOOT))
HELPINST_ALL = $(notdir $(HELPINST))

pic_always   = timer_a.jpg
PIC_INSTALL  = $(pic_always) back.jpg welcome.jpg mandriva.pcx star.dat
PIC_BOOT     = $(pic_always) back.jpg

in_cpio_always = init 16x16.fnt $(TRANSLATIONS)
IN_CPIO_INST = $(in_cpio_always)
IN_CPIO_BOOT = $(in_cpio_always) langs $(HELPBOOT_ALL) $(PIC_BOOT)

#- NB: we can't $(HELPINST_ALL) inside cpio for isolinux otherwise the cpio is too big and it fails
OUTSIDE_CPIO_INST   = langs $(HELPINST_ALL) $(PIC_INSTALL)
#- NB: we can't put things outside cpio for grub

FILES = 16x16.fnt $(PIC_INSTALL) $(PIC_BOOT) $(INCLUDES) help*.html Makefile po install.config boot.config langs grub-gfxmenu

sharedir=$(prefix)/usr/share
themedir=$(sharedir)/gfxboot/themes/Mandriva
sbindir=$(prefix)/usr/sbin

boot/%.hlp: help-boot.%.html boot
	$(HELP2TXT) --product=$(PRODUCT) $< >$@

inst/%.hlp: help-install.%.html inst
	$(HELP2TXT) --product=$(PRODUCT) $< >$@

.PHONY: all themes font aafont bitmapfont clean po

all: themes

boot.config:
	$(error run 'make prep' first)

boot inst: po
	mkdir -p $@

po:
	make -C po

themes: bootdir installdir

bootdir: boot.config po boot $(INCLUDES) $(HELPBOOT)
	@cp -a po/*.tr boot
	@for i in $(IN_CPIO_BOOT) ; do [ -f $$i ] && cp $$i boot ; done ; true
	$(MKBOOTMSG) $(BFLAGS) -l boot/log -c $< boot/init
	@sh -c 'cd boot; echo $(IN_CPIO_BOOT) | sed -e "s/ /\n/g" | cpio --quiet -o >message'
	@cd boot ; rm $(IN_CPIO_BOOT)

installdir: install.config po inst $(INCLUDES) $(HELPINST)
	@cp -a po/*.tr inst
	for i in $(IN_CPIO_INST) $(OUTSIDE_CPIO_INST) ; do [ -f $$i ] && cp $$i inst ; done ; true
	$(MKBOOTMSG) $(BFLAGS) -l inst/log -c $< inst/init
	@sh -c 'cd inst; chmod +t *'
	@sh -c 'cd inst; echo $(IN_CPIO_INST) | sed -e "s/ /\n/g" | cpio --quiet -o >bootlogo'
	@cd inst; rm $(IN_CPIO_INST)

install:
	mkdir -p $(themedir)/{boot,install}
	sh -c 'cd boot; install -m644 message $(themedir)/boot/message'
	sh -c 'cd inst; install -m644 bootlogo $(OUTSIDE_CPIO_INST) $(themedir)/install/'
	install -D grub-gfxmenu $(sbindir)/grub-gfxmenu

font: aafont

aafont:
	cat po/*.po *.html >tmp.txt
	mkblfont -v -l 18 \
	-c ISO-8859-15 -c ISO-8859-2 -c koi8-r \
	`keymapchars keymap.*.inc` \
	-t tmp.txt \
	-t inst/log -t boot/log \
	-t langs \
	-f NachlieliCLM-Bold:size=14:c=0x590-0x5ff \
	-f KacstOne:size=18:c=0x600-0x6ff,0xfe70-0xfefc:dy=6 \
	-f MuktiNarrow:size=18:c=0x0981-0x09fa:bold=1 \
	-f lohit_hi:size=18:c=0x0901-0x0970:bold=1 \
	-f lohit_pa:size=19:c=0x0a01-0x0a74:bold=1 \
	-f KhmerOSsys:size=16:c=0x1780-0x17f9:dy=-2 \
	-f DejaVuSans-Bold:size=14 \
	-f FZHeiTi:size=17:nobitmap=1 \
	-f gulim:size=17:bold=1:nobitmap=1 \
	16x16.fnt >16x16.fnt.log
	rm -f tmp.txt

bitmapfont:
	cat po/*.po *.html >tmp.txt
	mkblfont -v -l 18 \
	-c ISO-8859-15 -c ISO-8859-2 -c koi8-r \
	`keymapchars keymap.*.inc` \
	-t tmp.txt \
	-t inst/log -t boot/log \
	-t langs \
	-f b16_b:prop=2:space_width=6 \
	16x16.fnt >16x16.fnt.log
	rm -f tmp.txt

clean:
	[ ! -f po/Makefile ] || make -C po clean
	rm -f `find -type l`
	rmdir po 2>/dev/null || true
	rm -f *~ *.log
	rm -rf boot inst $(NAME).tar $(NAME)-$(VERSION)

prep:
	[ -e boot.config ] || { mkdir po ; ../../bin/adddir ../Mandriva . ; }
	[ ! -f po/Makefile ] || make -C po clean
	rm -f boot install *~ *.log
	rm -rf boot inst

changelog: ../../common/username.xml
	svn2cl --accum --authors ../../common/username.xml
	svn -m '' commit ChangeLog

dist: localdist

cleandist:
	rm -rf $(PACKAGE)-$(VERSION) $(PACKAGE).tar
dir:
	mkdir $(PACKAGE)-$(VERSION)
localcopy:
	tar c --exclude=.svn $(FILES) | tar x -C $(PACKAGE)-$(VERSION)

tar: clean dir localcopy
	tar cf $(PACKAGE).tar $(PACKAGE)-$(VERSION)
	rm -rf $(PACKAGE)-$(VERSION)

localdist: cleandist tar
