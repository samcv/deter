# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/shiki-colors/shiki-colors-4.6.ebuild,v 1.5 2014/10/13 15:34:52 pacho Exp $

EAPI=5

DESCRIPTION="Seven elegant themes for Murrine GTK+2 Cairo engine."
HOMEPAGE="http://code.google.com/p/gnome-colors/"

SRC_URI="http://gnome-colors.googlecode.com/files/${P}.tar.gz
         http://dev.gentoo.org/~pacho/Shiki-Gentoo-${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="x11-themes/gtk-engines-murrine"
DEPEND=""
RESTRICT="binchecks strip"

S="${WORKDIR}/"

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	dodir /usr/share/themes
	insinto /usr/share/themes
	doins -r "${WORKDIR}"/Shiki*
	dodoc AUTHORS ChangeLog README
}
