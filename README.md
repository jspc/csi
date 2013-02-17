CSI
==

_The Common Scripting Interface_

Rationale
--

Given two things:
 * The overhead of having to load random libs for simple scripting
 * The simplicity of pseudo-filesystems

CSI was written to allow for a simple IO based scripting environment; covering:

 * DateTime operations
 * Sys/ OS operations
 * Rand() operations
 * FS/ Stat() operations


Installation
--

 * Install `fuse` and `Fuse.pm` for your distribution

Personally I link the contents of `./bin` to `$HOME/bin` and `./lib/CSI` to `$HOME/lib` but your environment will be different.

