
VERSION?=0.0.1
PKGCONF=$(realpath makepkg.conf)
BUILDDIR=build
OUTPUTDIR=out
OUTPUTFILE=nt-atom-v${VERSION}.zip
OUTPUTPATH=${OUTPUTDIR}/${OUTPUTFILE}

${OUTPUTPATH}: pkgbuild
	mkdir -p ${BUILDDIR}
	find . -name "*.zst" -exec bash -c 'tar --use-compress-program=unzstd -xvf {} -C ${BUILDDIR}' \;
	7z a -tzip ${OUTPUTPATH} -w ${BUILDDIR}/.
	md5sum ${OUTPUTPATH} >${OUTPUTDIR}/checksum.md5

pkgbuild:
	find . -name "PKGBUILD" -exec bash -c 'pushd `dirname {}` && makepkg --config ${PKGCONF} && popd' \;

updpkgsums:
	find . -name "PKGBUILD" -exec bash -c 'pushd `dirname {}` && updpkgsums && popd' \;

update_github:
	find . -name "PKGBUILD" -exec utils/update.sh {} \;

update: update_github updpkgsums

clean:
	git clean -xfd

.PHONY: clean pkgbuild updpkgsums update
