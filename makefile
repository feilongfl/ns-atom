
VERSION?=0.0.1
PKGCONF=$(realpath makepkg.conf)
TOPDIR=$(realpath .)
BUILDDIR=build
OUTPUTDIR=out
OUTPUTFILE=nt-atom-v${VERSION}.zip
OUTPUTPATH=${OUTPUTDIR}/${OUTPUTFILE}

${OUTPUTPATH}: pkgreports
	mkdir -p ${BUILDDIR}
	find . -name "*.zst" -exec bash -c 'tar --use-compress-program=unzstd -xvf {} -C ${BUILDDIR}' \;
	cp ${TOPDIR}/readme.md ${BUILDDIR}/
	7z a -tzip ${OUTPUTPATH} -w ${BUILDDIR}/.
	md5sum ${OUTPUTPATH} >${OUTPUTDIR}/checksum.md5

pkgbuild:
	find . -name "PKGBUILD" -exec bash -c 'pushd `dirname {}` && echo ❌ > status && makepkg -f --config ${PKGCONF} && cat PKGBUILD | grep "^pkgver" | cut -d '=' -f 2 > status && popd' \;

updpkgsums:
	find . -name "PKGBUILD" -exec bash -c 'pushd `dirname {}` && updpkgsums && popd' \;

update_github:
	find . -name "PKGBUILD" -exec utils/update.sh {} \;

update: update_github updpkgsums

pkgreports: pkgbuild
	find . -name "status" -exec bash -c 'pushd `dirname {}` && echo "| ["`dirname {}`"]("`dirname {}`/PKGBUILD") | "`cat status`" |" >> ${TOPDIR}/readme.md && popd' \;

clean:
	git clean -xfd

.PHONY: clean pkgbuild updpkgsums update pkgbuild
