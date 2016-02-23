# Copyright 1999-2010 Tiziano Müller
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="Display graphical dialogs from shell scripts or command line (a Zenity-fork)"
HOMEPAGE="http://code.google.com/p/yad/"
SRC_URI="http://yad.googlecode.com/files/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	dev-libs/glib:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext
	dev-util/intltool
	app-arch/xz-utils"

src_configure() {
	econf \
		--disable-deprecated
}
