[![Current Version](https://raw.githubusercontent.com/simons-containers/distroless-python/badges/.badges/main/release.svg)](https://github.com/simons-containers/distroless-python/pkgs/container/distroless-python) [![Tags](https://raw.githubusercontent.com/simons-containers/distroless-python/badges/.badges/main/tags.svg)](https://github.com/simons-containers/distroless-python/pkgs/container/distroless-python) <br> ![Current Size](https://raw.githubusercontent.com/simons-containers/distroless-python/badges/.badges/main/size.svg) ![Wasted Size](https://raw.githubusercontent.com/simons-containers/distroless-python/badges/.badges/main/wasted.svg) ![Efficiency](https://raw.githubusercontent.com/simons-containers/distroless-python/badges/.badges/main/efficiency.svg) <br> ![Critical](https://raw.githubusercontent.com/simons-containers/distroless-python/badges/.badges/main/critical.svg) ![High](https://raw.githubusercontent.com/simons-containers/distroless-python/badges/.badges/main/high.svg) ![Medium](https://raw.githubusercontent.com/simons-containers/distroless-python/badges/.badges/main/medium.svg) ![Low](https://raw.githubusercontent.com/simons-containers/distroless-python/badges/.badges/main/low.svg) <br> [![Publish Workflow](https://img.shields.io/github/actions/workflow/status/simons-containers/distroless-python/deploy.yaml?label=Publish%20Workflow&logo=github)](https://github.com/simons-containers/distroless-python/actions/workflows/deploy.yaml) [![Update Workflow](https://img.shields.io/github/actions/workflow/status/simons-containers/distroless-python/update-versions.yaml?label=Update%20Workflow&logo=github)](https://github.com/simons-containers/distroless-python/actions/workflows/update-versions.yaml)

# Distroless Python container

Bare-bones distroless Python container image.


## Running

No `ENTRYPOINT` is specified in the base container.

```bash
docker run -it --rm ghcr.io/simons-containers/distroless-python:latest /usr/bin/python -m this
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
