# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit xdg-utils desktop

DESCRIPTION="Master PDF Editor is a complete solution for viewing and editing PDF files"
HOMEPAGE="https://code-industry.net/free-pdf-editor/"
SRC_URI="https://code-industry.net/public/${P}_qt5.amd64.tar.gz"

LICENSE="master-pdf-editor"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

COMMON_DEPEND="
	app-arch/bzip2
	dev-libs/double-conversion
	dev-libs/glib
	dev-libs/icu
	dev-libs/openssl
	media-gfx/graphite2
	media-gfx/sane-backends
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/libjpeg-turbo
	media-libs/libpng
	media-libs/tiff
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdmcp
	x11-libs/libXext
	>=dev-qt/qtsvg-5.4:5
	>=dev-qt/qtnetwork-5.4:5
	>=dev-qt/qtgui-5.4:5
	>=dev-qt/qtprintsupport-5.4:5
"

RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/${PN}-${PV%%.*}"

src_install() {
	insinto /opt/${PN}
	doins -r fonts lang stamps templates masterpdfeditor5.png

	exeinto /opt/${PN}
	doexe masterpdfeditor5

	dosym ../${PN}/masterpdfeditor5 /opt/bin/masterpdfeditor5
	make_desktop_entry "masterpdfeditor5 %f" \
		"Master PDF Editor ${PV}" /opt/${PN}/masterpdfeditor5.png \
		"Office;Graphics;Viewer" \
		"MimeType=application/pdf;application/x-bzpdf;application/x-gzpdf;\nTerminal=false"
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
