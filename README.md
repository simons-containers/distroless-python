# Distroless Python container

Bare-bones distroless Python container image.

## Building

| Build Arg | Description |
|---|---|
| `GCC_VERSION` | Version of gcc to use
| `ZLIB_VERSION` | Version of zlib to use
| `OPENSSL_VERSION` | Version of openssl to use
| `NCURSES_VERSION` | Version of ncurses to use
| `READLINE_VERSION` | Version of readline to use
| `LIBFFI_VERSION` | Version of libffi to use
| `BZIP2_VERSION` | Version of bzip2 to use
| `XZ_VERSION` | Version of xz to use

Build container using build-args from versions.yaml:

```bash
docker build -t python $(yq -r 'to_entries | .[] | "--build-arg \(.key | ascii_upcase)_VERSION=\(.value)"' versions.yaml) -f Containerfile .
```

## License

Repository contents (e.g., `Containerfile`, build scripts, and configuration) are licensed under the **MIT License**.

Software included in built container images (such as **Python**, **gcc**, **OpenSSL**, etc...) are provided under their respective upstream licenses and are not covered by the MIT license for this repository.

## Acknowledgements

This project depends on several upstream components that provide essential runtime libraries, toolchains, and platform capabilities:

- **Python** – Python is a programming language that lets you work quickly and integrate systems more effectively.  
  https://www.python.org

- **GCC** – The GNU Compiler Collection, providing the C and C++ toolchain used to build core system components and application code.  
  https://gcc.gnu.org/

- **zlib** – A foundational compression library implementing the DEFLATE algorithm, widely used across system software for efficient data compression and decompression.  
  https://zlib.net/

- **OpenSSL** – A comprehensive cryptographic library offering TLS, hashing, and encryption primitives required for secure communication and data integrity.  
  https://www.openssl.org/

- **Ncurses** - ncurses (new curses) is a programming library for creating textual user interfaces (TUIs) that work across a wide variety of terminals.  
  https://invisible-island.net/ncurses/

- **Readline** - The GNU Readline library provides a set of functions for use by applications that allow users to edit command lines as they are typed in.  
  https://tiswww.case.edu/php/chet/readline/rltop.html

- **libffi** - A portable foreign-function interface library.  
  https://sourceware.org/libffi

- **bzip2** - bzip2 is a freely available, patent free, high-quality data compressor.  
   https://sourceware.org/bzip2/

- **xz** - XZ Utils are a complete C99 implementation of the .xz file format.  
  https://tukaani.org/xz/

- **glibc** – GNU C Library providing the standard C runtime and POSIX interfaces used by most Linux systems.  
  https://www.gnu.org/software/libc/

- **tzdata** – The IANA Time Zone Database, which provides the canonical global timezone definitions used for correct time handling.  
  https://www.iana.org/time-zones

- **Mozilla CA Certificates** – The curated set of trusted root Certificate Authorities maintained by Mozilla and used by many systems for TLS verification.  
  https://wiki.mozilla.org/CA