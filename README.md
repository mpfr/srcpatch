# srcpatch

Keeps source trees up-to-date just by applying the patch files provided en passant by the [syspatch(8)](http://man.openbsd.org/syspatch) utility.

For further information, please have a look at the [manpage](https://mpfr.github.io/srcpatch/srcpatch.8.html).

## How to install

Make sure you're running `OpenBSD-current`. Otherwise, one of the following branches might be more appropriate:
* [6.7-stable](https://github.com/mpfr/srcpatch/tree/6.7-stable)

Make sure your user has sufficient `doas` permissions. To start, `cd` into the user's home directory, here `/home/mpfr`.

```
$ cat /etc/doas.conf
permit nopass mpfr
$ cd
$ pwd
/home/mpfr
```

Get the sources downloaded and extracted.

```
$ rm -rf srcpatch-current/
$ ftp -Vo - https://codeload.github.com/mpfr/srcpatch/tar.gz/current | tar xzvf -
srcpatch-current
srcpatch-current/LICENSE
srcpatch-current/README.md
srcpatch-current/docs
srcpatch-current/docs/mandoc.css
srcpatch-current/docs/srcpatch.8.html
srcpatch-current/src
srcpatch-current/src/Makefile
srcpatch-current/src/srcpatch.8
srcpatch-current/src/srcpatch.sh
```

Install tool and manpage.

```
$ cd srcpatch-current/src
$ doas make install
install -c -o root -g bin -m 555  /home/mpfr/srcpatch-current/src/srcpatch.sh ...
install -c -o root -g bin -m 444  srcpatch.8 ...
```

## How to uninstall

```
$ doas rm /usr/local/man/man8/srcpatch.8
$ doas rm /usr/local/sbin/srcpatch
```
