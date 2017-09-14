# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2-utils

DESCRIPTION="GNOME-colors icon themes made by Victor Castillejo (perfectska04). Suit well with Shiki-colors GTK themes. This version fixes inheritance on ‘gnome’ theme – which doesn’t work anymore – to Adwaita."
HOMEPAGE="https://code.google.com/p/gnome-colors/"

SRC_URI="https://github.com/deterenkelt/gnome-colors-themes/releases/download/v${PV}/${PN}-${PV}.tar.gz"

LICENSE="GPL-2 public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-themes/gnome-colors-common
         x11-themes/adwaita-icon-theme"
DEPEND=""

RESTRICT="binchecks strip"

S="${WORKDIR}"

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	dodir /usr/share/icons
	insinto /usr/share/icons
	for i in gnome*; do
		if [ "$i" != "gnome-colors-common" ]; then
			doins -r "${i}" || die
		fi
	done
	einstalldocs
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
