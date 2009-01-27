POFILES	= $(wildcard *.po)
TEXTS	= $(addsuffix .tr,$(basename $(wildcard *.po)))

PRODUCT = $(shell perl -ne 'print if s/^product=//' ../config)

all: .ready

.ready: text.inc $(TEXTS)
	@touch .ready

# the po2txt script requires that the po file has no fuzzy entries
# and the same comments as the pot file; so we do a msgfmt/msgunfmt/msgmerge
# to ensure that
%.tr: %.po text.inc
	msgfmt $< -o - | msgunfmt | \
	msgmerge --no-fuzzy-matching - bootloader.pot > tmpfile.po && \
	bin/po2txt --product='$(PRODUCT)' tmpfile.po >$@
	echo rm -f tmpfile.po

# en.tr uses msgids from bootloader.pot
en.tr text.inc: bootloader.pot
	bin/po2txt --product='$(PRODUCT)' $< >en.tr

clean:
	rm -f .ready text.inc *.tr *~ talk/*~


update_n_merge: bootloader.pot merge

merge:
	for n in *.po; do \
	  echo "Merging $$n"; \
	  msgmerge -C $$n $$n bootloader.pot > "$$n"t ; \
	  mv -f "$$n"t $$n ; \
	done
