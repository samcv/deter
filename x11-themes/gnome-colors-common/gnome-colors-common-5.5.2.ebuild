# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2-utils

DESCRIPTION="Colorized icons shared between all gnome-colors iconsets"
HOMEPAGE="https://code.google.com/p/gnome-colors/"

SRC_URI="https://github.com/deterenkelt/gnome-colors-themes/releases/download/v5.5.2/gnome-colors-themes-5.5.2.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-themes/adwaita-icon-theme"
DEPEND=""
RESTRICT="binchecks strip"

S="${WORKDIR}"

src_prepare() {
	default
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	dodir /usr/share/icons
	insinto /usr/share/icons
	doins -r "${WORKDIR}/${PN}" || die "Installing icons failed"
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
