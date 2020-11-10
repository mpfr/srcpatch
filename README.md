# srcpatch

Keeps source trees up-to-date just by applying the patch files provided en passant by the [syspatch(8)](http://man.openbsd.org/syspatch) utility.

For further information, please have a look at the [manpage](https://mpfr.github.io/srcpatch/srcpatch.8.html).

## How to install

If you are running `OpenBSD-current`, installing `srcpatch` is not supported as it strongly depends on the `syspatch(8)` utility which solely works on official releases. Hence, this is a development-only branch that is used for adjustments to the ongoing `OpenBSD` development process.

In case you are running an official release, though, one of the following branches might be more appropriate:
* [6.8-stable](https://github.com/mpfr/srcpatch/tree/6.8-stable)
* [6.7-stable](https://github.com/mpfr/srcpatch/tree/6.7-stable)
