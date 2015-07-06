# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit distutils

DESCRIPTION="Task management GUI tool"
HOMEPAGE="http://nitrotasks.com/"
SRC_URI="https://launchpad.net/nitrotasks/trunk/${PV}/+download/${PN}_${PV}.tar.gz"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/python-distutils-extra"
RDEPEND="dev-python/pywebkitgtk"

S="${WORKDIR}"/${PN}
