
MAN=		srcpatch.8

SCRIPT=		srcpatch

BINDIR?=	/usr/local/sbin
MANDIR?=	/usr/local/man/man

realinstall:
	${INSTALL} ${INSTALL_COPY} -o ${BINOWN} -g ${BINGRP} -m ${BINMODE} \
		${.CURDIR}/${SCRIPT}.sh ${DESTDIR}${BINDIR}/${SCRIPT}

uninstall:
	-rm ${BINDIR}/${SCRIPT} ${MANDIR}8/${MAN}

.include <bsd.prog.mk>
