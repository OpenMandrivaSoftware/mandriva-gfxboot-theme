BINDIR      := $(shell [ -x ../../gfxboot-compile ] && echo ../../ )

BASED_ON     = $(shell perl -ne 'print if s/^based_on=//' config)

ifeq ($(BASED_ON),)
PREPARED     = 1
else
PREPARED     = $(shell [ -f .prepared ] && echo 1)
endif

ADDDIR       = gfxboot-adddir
BFLAGS       = -O -v -L ../..

SUBDIRS      = fonts help-boot help-install po src

IN_CPIO_INSTALL = init $(notdir $(wildcard fonts/*.fnt)) $(notdir $(wildcard po/*.tr))

DEFAULT_LANG =

.PHONY: all clean distclean themes $(SUBDIRS)

ifeq ($(PREPARED), 1)

  all: bootlogo message

else

  all:
	$(ADDDIR) ../$(BASED_ON) .
	make clean
	touch .prepared
	make

endif

themes: all

%/.ready: %
	make -C $*

src/main.bin: src
	make -C src

bootlogo: src/main.bin help-install/.ready po/.ready fonts/.ready
	@rm -rf bootlogo.dir
	@mkdir bootlogo.dir
	cp -rL data-install/* fonts/*.fnt po/*.tr bootlogo.dir
	cp -rL help-install/*.hlp bootlogo.dir
	cp src/main.bin bootlogo.dir/init
ifdef DEFAULT_LANG
	@echo $(DEFAULT_LANG) >bootlogo.dir/lang
endif
	@sh -c 'cd bootlogo.dir; chmod +t * ; chmod -t init langs'
	@sh -c 'cd bootlogo.dir; echo $(IN_CPIO_INSTALL) | sed -e "s/ /\n/g" | cpio --quiet -o >../bootlogo'
	@cd bootlogo.dir; rm $(IN_CPIO_INSTALL)

message: src/main.bin help-boot/.ready po/.ready fonts/.ready
	@rm -rf message.dir
	@mkdir message.dir
	cp -rL data-boot/* fonts/*.fnt message.dir
	cp -rL po/*.tr help-boot/*.hlp message.dir
	cp src/main.bin message.dir/init
ifdef DEFAULT_LANG
	cp -rL po/$(DEFAULT_LANG).tr help-boot/$(DEFAULT_LANG).hlp message.dir
	@echo $(DEFAULT_LANG) >message.dir/lang
	@echo $(DEFAULT_LANG) >>message.dir/langs
endif
	@sh -c 'cd message.dir; echo * | sed -e "s/ /\n/g" | cpio --quiet -o >../message'
	@rm -r message.dir

clean:
	@for i in $(SUBDIRS) ; do [ ! -f $$i/Makefile ] ||  make -C $$i clean || break ; done
	rm -rf bootlogo bootlogo.dir message message.dir *~

distclean: clean
ifneq ($(BASED_ON),)
	rm -f .prepared
	rm -f `find -type l \! -wholename ./Makefile`
	rmdir `find -depth -type d \! -name . \! -name .svn \! -wholename './.svn/*' \! -wholename './*/.svn/*'` 2>/dev/null || true
endif


NAME = mandriva-gfxboot-theme
UPSTREAM_VERSION = 4.1.19
VERSION = $(UPSTREAM_VERSION).10

dist:
	rm -rf ../$(NAME)-$(VERSION).tar*
	@if [ -e ".svn" ]; then \
	    $(MAKE) dist-svn; \
	elif [ -e ".git" ]; then \
	    $(MAKE) dist-git; \
	else \
	    echo "Unknown SCM (not SVN nor GIT)";\
	    exit 1; \
	fi;
	$(info $(NAME)-$(VERSION).tar.lzma is ready)

dist-svn:
	rm -rf $(NAME)-$(VERSION) 
	svn export -q -rBASE . $(NAME)-$(VERSION)
	tar cfY ../$(NAME)-$(VERSION).tar.lzma $(NAME)-$(VERSION)
	rm -rf $(NAME)-$(VERSION)

dist-git:
	@git archive --prefix=$(NAME)-$(VERSION)/ HEAD | lzma >../$(NAME)-$(VERSION).tar.lzma;	
