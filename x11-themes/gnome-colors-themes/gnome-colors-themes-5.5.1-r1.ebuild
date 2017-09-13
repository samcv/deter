# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2-utils

DESCRIPTION="Some gnome-colors iconsets including a Gentoo one"
HOMEPAGE="https://code.google.com/p/gnome-colors/"

SRC_URI="https://gnome-colors.googlecode.com/files/gnome-colors-${PV}.tar.gz
	https://dev.gentoo.org/~pacho/gnome-gentoo-${PV}.tar.gz"

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
	# ‘gnome’ theme is kind of deprecated,
	# and gnome-colors-common now fails to inherit it.
	sed -ri 's/\s*Inherits=gnome\s*/Inherits=Adwaita/' /usr/share/icons/gnome-colors-common/index.theme
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
