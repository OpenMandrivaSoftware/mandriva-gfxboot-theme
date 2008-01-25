POFILES	= $(wildcard *.po)
TEXTS	= $(addsuffix .tr,$(basename $(wildcard *.po)))

PRODUCT ?= "SUSE Linux 10.1"

all: text.inc $(TEXTS)

# the po2txt script requires that the po file has no fuzzy entries
# and the same comments as the pot file; so we do a msgfmt/msgunfmt/msgmerge
# to ensure that
%.tr: %.po text.inc
	msgfmt $< -o - | msgunfmt | \
	msgmerge --no-fuzzy-matching - bootloader.pot > tmpfile.po && \
	bin/po2txt --product=$(PRODUCT) tmpfile.po >$@
	echo rm -f tmpfile.po

# en.tr uses msgids from bootloader.pot
en.tr text.inc: bootloader.pot
	bin/po2txt --product=$(PRODUCT) $< >en.tr

clean:
	rm -f text.inc *.tr *~


merge: bootloader.pot
	for n in *.po; do \
	  echo "Merging $$n"; \
	  msgmerge -C $$n $$n bootloader.pot > "$$n"t ; \
	  mv -f "$$n"t $$n ; \
	done
