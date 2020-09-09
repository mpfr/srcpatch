# srcpatch

Keeps source trees up-to-date just by applying the patch files provided en passant by the [syspatch(8)](http://man.openbsd.org/syspatch) utility.

For more information, just have a look at the [manpage](https://mpfr.github.io/srcpatch/srcpatch.8.html).

## How to install

Make sure your user has sufficient `doas` permissions. To start, `cd` into the user's home directory, here `/home/mpfr`.

```
$ cat /etc/doas.conf
permit nopass mpfr
$ cd
$ pwd
/home/mpfr
$
```

Get the sources downloaded and extracted.

```
$ ftp -Vo - https://codeload.github.com/mpfr/srcpatch/tar.gz/master | tar xzvf -
srcpatch-master
srcpatch-master/README.md
srcpatch-master/docs
srcpatch-master/docs/mandoc.css
srcpatch-master/docs/srcpatch.8.html
srcpatch-master/src
srcpatch-master/src/Makefile
srcpatch-master/src/srcpatch.8
srcpatch-master/src/srcpatch.sh
$
```

Install tool and manpage.

```
$ cd srcpatch-master/src
$ doas make install
install -c -o root -g bin -m 555  /home/mpfr/srcpatch-master/src/srcpatch.sh ...
install -c -o root -g bin -m 444  srcpatch.8 ...
$
```

## How to uninstall

```
$ doas rm /usr/local/man/man8/srcpatch.8
$ doas rm /usr/local/sbin/srcpatch
$
```
