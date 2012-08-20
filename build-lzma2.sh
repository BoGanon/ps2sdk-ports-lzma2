#!/bin/sh

# Trying to generalize it a bit so I don't need to modify it all that much
# per package

# Custom variables
_PKGNAME="ps2sdk-ports-lzma2"
_GITROOT=http://git.tukaani.org/xz-embedded.git
_GITNAME=xz-embedded
_GITBRANCH=master

# Various handy variables
_TOPDIR="${PWD}"
_SRCDIR="${PWD}/src"
_PKGDIR="${PWD}/${_PKGNAME}"

echo "\033[01;36mDownloading sources...\033[00m"
if [ -d "${_GITNAME}" ]; then
	echo "Found existing copy..."
	echo "Checking for updates..."
	cd "${_GITNAME}"
	git checkout "${_GITBRANCH}"
	# In case of a rebase of the current commit
	# for a personal version of the repository
	# git reset --hard HEAD~1
	git pull
else
	echo "${_GITNAME} not found."
	echo "Checking out fresh copy..."
	git clone "${_GITROOT}"
	cd "${_GITNAME}"
	git checkout "${_GITBRANCH}"
fi

echo "\033[01;36mChecking for source directory...\033[00m"
if [ -d "${_SRCDIR}" ]; then
	echo "${_SRCDIR} found."
	echo "Removing..."
	rm -r "${_SRCDIR}"
else
	echo "${_SRCDIR} not found."

fi

echo "\033[01;36mChecking for package directory...\033[00m"
if [ -d "${_PKGDIR}" ]; then
	echo "${_PKGDIR} found."
	echo "Removing..."
	rm -r "${_PKGDIR}"
else
	echo "${_PKGDIR} not found."
fi

echo "Making directories..."
mkdir "${_SRCDIR}"
mkdir "${_PKGDIR}"

echo "\033[01;36mExtracting sources to directory...\033[00m"
cp linux/include/linux/xz.h "${_SRCDIR}"/
cp linux/lib/xz/xz_crc32.c "${_SRCDIR}"/
cp linux/lib/xz/xz_dec_lzma2.c "${_SRCDIR}"/
cp linux/lib/xz/xz_dec_stream.c "${_SRCDIR}"/
cp linux/lib/xz/xz_lzma2.h "${_SRCDIR}"/
cp linux/lib/xz/xz_private.h "${_SRCDIR}"/
cp linux/lib/xz/xz_stream.h "${_SRCDIR}"/
cp userspace/xz_config.h "${_SRCDIR}"/

cd ${_TOPDIR}

# Put in the custom commands for building and packaging
echo "\033[01;36mBuilding package...\033[00m"

cp stdint.h "${_SRCDIR}"/
cp lzma2.h "${_SRCDIR}"/
cp lzma2.c "${_SRCDIR}"/
cp Makefile "${_SRCDIR}"/

cd "${_SRCDIR}"
make || return 1
make DESTDIR=${_PKGDIR} install || return 1
make clean

# End putting custom commands
echo "\033[01;36mInstalling DEBIAN package files...\033[00m"
install -m755 -d ${_PKGDIR}/DEBIAN
cp -r ${_TOPDIR}/DEBIAN/ ${_PKGDIR}

echo "\033[01;36mCreating DEBIAN package...\033[00m"
cd ${_TOPDIR}
dpkg-deb -z8 -Zgzip --build ${_PKGNAME}

exit 0

