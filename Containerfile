FROM archlinux:base-devel-20260308.0.497099 AS builder

ARG PYTHON_VERSION
ARG GCC_VERSION
ARG ZLIB_VERSION
ARG OPENSSL_VERSION
ARG NCURSES_VERSION
ARG READLINE_VERSION
ARG LIBFFI_VERSION
ARG BZIP2_VERSION
ARG XZ_VERSION

ARG PYTHON_SOURCE=https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
ARG GCC_SOURCE=https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.xz
ARG ZLIB_SOURCE=https://zlib.net/zlib-${ZLIB_VERSION}.tar.gz
ARG OPENSSL_SOURCE=https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
ARG NCURSES_SOURCE=https://ftp.gnu.org/pub/gnu/ncurses/ncurses-${NCURSES_VERSION}.tar.gz
ARG READLINE_SOURCE=https://ftp.gnu.org/pub/gnu/readline/readline-${READLINE_VERSION}.tar.gz
ARG LIBFFI_SOURCE=https://github.com/libffi/libffi/releases/download/v${LIBFFI_VERSION}/libffi-${LIBFFI_VERSION}.tar.gz
ARG BZIP2_SOURCE=https://sourceware.org/pub/bzip2/bzip2-${BZIP2_VERSION}.tar.gz
ARG XZ_SOURCE=https://tukaani.org/xz/xz-${XZ_VERSION}.tar.gz

RUN pacman -Sy --noconfirm python wget >/dev/null

WORKDIR /build/gcc
RUN curl --silent --show-error --location --output gcc.tar.gz \
    "${GCC_SOURCE}" \
    && tar xf gcc.tar.gz --strip-components=1 \
    && ./contrib/download_prerequisites \
    && mkdir build && cd build \
    && ../configure \
        --prefix=/usr \
        --libdir=/usr/lib \
        --libexecdir=/usr/lib \
        --disable-multilib \
        --disable-bootstrap \
        --enable-languages=c,c++ \
    && make -j$(nproc) all-target-libgcc all-target-libstdc++-v3 \
    && mkdir -p /base/usr/lib && ln -s lib /base/usr/lib64 \
    && make install-target-libgcc DESTDIR=/base \
    && make install-target-libstdc++-v3 DESTDIR=/base

WORKDIR /build/zlib
RUN curl --silent --show-error --location --output zlib.tar.gz \
    "${ZLIB_SOURCE}" \
    && tar xf zlib.tar.gz --strip-components=1 \
    && ./configure --prefix=/usr \
    && make -s -j$(nproc) \
    && make install DESTDIR=/base

WORKDIR /build/openssl
RUN curl --silent --show-error --location --output openssl.tar.gz \
    "${OPENSSL_SOURCE}" \
    && tar xf openssl.tar.gz --strip-components=1 \
    && ./Configure linux-x86_64 --prefix=/usr --libdir=/usr/lib no-tests no-docs \
        --with-zlib-include=/base/usr/include --with-zlib-lib=/base/usr/lib \
    && make -s -j$(nproc) \
    && make install_sw DESTDIR=/base

WORKDIR /build/ncurses
RUN curl --silent --show-error --location --output ncurses.tar.gz \
    "${NCURSES_SOURCE}" \
    && tar xf ncurses.tar.gz --strip-components=1 \
    && ./configure --prefix=/usr --with-shared --without-debug \
        --without-ada --enable-widec --without-cxx \
    && make -s -j$(nproc) \
    && make install DESTDIR=/base

WORKDIR /build/readline
RUN curl --silent --show-error --location --output readline.tar.gz \
    "${READLINE_SOURCE}" \
    && tar xf readline.tar.gz --strip-components=1 \
    && CPPFLAGS="-I/base/usr/include" LDFLAGS="-L/base/usr/lib" \
        ./configure --prefix=/usr --with-curses --enable-multibyte \
    && make -s -j$(nproc) \
    && make install DESTDIR=/base

WORKDIR /build/libffi
RUN curl --silent --show-error --location --output libffi.tar.gz \
    "${LIBFFI_SOURCE}" \
    && tar xf libffi.tar.gz --strip-components=1 \
    && ./configure --prefix=/usr --disable-static \
    && make -s -j$(nproc) \
    && make install DESTDIR=/base

WORKDIR /build/bzip2
RUN curl --silent --show-error --location --output bzip2.tar.gz \
    "${BZIP2_SOURCE}" \
    && tar xf bzip2.tar.gz --strip-components=1 \
    && make -s -j$(nproc) CFLAGS="-fPIC -O2" \
    && make install PREFIX=/usr DESTDIR=/base

WORKDIR /build/xz
RUN curl --silent --show-error --location --output xz.tar.gz \
    "${XZ_SOURCE}" \
    && tar xf xz.tar.gz --strip-components=1 \
    && ./configure --prefix=/usr --disable-static \
    && make -s -j$(nproc) \
    && make install DESTDIR=/base

WORKDIR /build/python
RUN curl --silent --show-error --location --output python.tar.gz \
    "${PYTHON_SOURCE}" \
    && tar xf python.tar.gz --strip-components=1 \
    && CPPFLAGS="-I/base/usr/include" LDFLAGS="-L/base/usr/lib" \
        ./configure \
        --prefix=/usr \
        --enable-optimizations \
        --with-lto \
        --with-openssl=/base/usr \
        --enable-shared \
        --with-ensurepip=install \
    && make -s -j$(nproc) \
    && make install DESTDIR=/base \
    && ln -s python3 /base/usr/bin/python \
    && ln -s pip3 /base/usr/bin/pip

RUN rm -fr /base/usr/lib/{pkgconfig,cmake} /base/usr/share/{man,info,doc} \
    /base/usr/share/readline /base/usr/share/tabset /base/usr/lib64 \
    /base/usr/bin/{c_rehash,captoinfo,clear,infocmp,infotocap,openssl} \
    /base/usr/bin/{reset,tabs,tic,toe,tput,tset,unlzma,unxz} \
    /base/usr/bin/idle* /base/usr/bin/lz* /base/usr/bin/ncurses* /base/usr/bin/xz* \
    /base/usr/lib/python*/config-*-linux-gnu \
    /base/usr/lib/python*/{test,idlelib,tkinter,ensurepip,pydoc_data} \
    && find /base/usr -type f \
        \( -name '*.h' -o -name '*.a' -o -name '*.o' -o -name '*.la' \) -delete \
    && find /base/usr -type f \
        \( -name '*.txt' -o -name '*.md' \) -delete \
    && find /base/usr -type d -name __pycache__ -exec rm -rf "{}" + \
    && find /base/usr/share/terminfo -type f ! \
        \( -path './s/screen*' -o -path './x/xterm*' -o -path './v/vt*' \) -delete \
    && find /base/usr/lib -type f \( -name '*.so' -o -name '*.so.*' \) \
            -print -exec sh -c 'strip --strip-unneeded "$1" || :' _ "{}" +

FROM ghcr.io/simons-containers/distroless-glibc

ARG PYTHON_VERSION
ARG GCC_VERSION
ARG ZLIB_VERSION
ARG OPENSSL_VERSION
ARG NCURSES_VERSION
ARG READLINE_VERSION
ARG LIBFFI_VERSION
ARG BZIP2_VERSION
ARG XZ_VERSION

COPY --from=builder /base/usr/lib/ /usr/lib/
COPY --from=builder /base/usr/share/ /usr/share/
COPY --from=builder /base/usr/bin/ /usr/bin/

LABEL org.opencontainers.image.title="distroless python"
LABEL org.opencontainers.image.description="distroless python"
LABEL org.opencontainers.image.version="${PYTHON_VERSION}"
LABEL org.opencontainers.image.source="https://github.com/simons-containers/distroless-python"
LABEL org.opencontainers.image.base.libs="python@${PYTHON_VERSION},gcc@${GCC_VERSION},zlib@${ZLIB_VERSION},openssl@${OPENSSL_VERSION},ncurses@$${NCURSES_VERSION},readline@${READLINE_VERSION},libffi@${LIBFFI_VERSION},bzip2@${BZIP2_VERSION},xz@${XZ_VERSION}"