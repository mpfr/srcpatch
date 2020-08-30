
MAN=    srcpatch.8

SCRIPT= srcpatch.sh

BINDIR?=	/usr/local/sbin
MANDIR?=	/usr/local/man/man

realinstall:
	${INSTALL} ${INSTALL_COPY} -o ${BINOWN} -g ${BINGRP} -m ${BINMODE} \
		${.CURDIR}/${SCRIPT} ${DESTDIR}${BINDIR}/srcpatch

.include <bsd.prog.mk>
