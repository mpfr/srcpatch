# srcpatch

Keeps source trees up-to-date just by applying the patch files provided en passant by the [syspatch(8)](http://man.openbsd.org/syspatch) utility.

For further information, please have a look at the [manpage](https://mpfr.net/man/srcpatch/8.0-stable/srcpatch.8.html).

## How to install

Make sure you're running `OpenBSD 8.0-stable`. Otherwise, one of the following branches might be more appropriate:
* [7.9-stable](https://github.com/mpfr/srcpatch/tree/7.9-stable)

Then, make sure your user (e.g. `mpfr`) has sufficient `doas` permissions.

```
$ cat /etc/doas.conf
permit nopass mpfr
```

Download and extract the source files into the user's home directory, here `/home/mpfr`.

```
$ cd
$ pwd
/home/mpfr
$ doas rm -rf srcpatch-8.0-stable/
$ ftp -Vo - https://codeload.github.com/mpfr/srcpatch/tar.gz/8.0-stable | tar xzvf -
srcpatch-8.0-stable
srcpatch-8.0-stable/LICENSE
srcpatch-8.0-stable/README.md
srcpatch-8.0-stable/docs
srcpatch-8.0-stable/docs/srcpatch.8.html
srcpatch-8.0-stable/src
srcpatch-8.0-stable/src/Makefile
srcpatch-8.0-stable/src/srcpatch.8
srcpatch-8.0-stable/src/srcpatch.sh
```

Install tool and manpage.

```
$ cd srcpatch-8.0-stable/src
$ doas make install
install -c -o root -g bin -m 555  /home/mpfr/srcpatch-8.0-stable/src/srcpatch.sh ...
install -c -o root -g bin -m 444  srcpatch.8 ...
```

## How to uninstall

```
$ cd ~/srcpatch-8.0-stable/src
$ doas make uninstall
rm /usr/local/sbin/srcpatch /usr/local/man/man8/srcpatch.8
```