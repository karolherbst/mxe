# This file is part of MXE.
# See index.html for further information.

PKG             := jansson
$(PKG)_VERSION  := 2.7
$(PKG)_CHECKSUM := 7d8686d84fd46c7c28d70bf2d5e8961bc002845e
$(PKG)_SUBDIR   := jansson-$($(PKG)_VERSION)
$(PKG)_FILE     := jansson-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.digip.org/jansson/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- http://www.digip.org/jansson/releases/ |
    $(SED) -n 's,.*jansson-\([1-9]\.[0-9]\.*[0-9]*\)\..*,\1,p' |
    $(UNIQ) |
    $(SORT) -V |
    tail -1
endef

define $(PKG)_BUILD
	cd '$(1)' && autoreconf -fi
    cd '$(1)' && libtoolize --install --copy --force --automake
    cd '$(1)' && aclocal
    cd '$(1)' && autoconf
    cd '$(1)' && autoheader
    cd '$(1)' && automake --add-missing --copy --foreign --force-missing
    cd '$(1)' && libtoolize
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-dependency-tracking \
        --disable-silent-rules
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
