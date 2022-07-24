
PKGCONF=$(realpath makepkg.conf)

sd.zip: pkgbuild
	echo ${PKGCONF}

pkgbuild:
	find . -name "PKGBUILD" -exec bash -c 'pushd `dirname {}` && makepkg --config ${PKGCONF} && popd' \;

clean:
	git clean -xfd

.PHONY: clean pkgbuild
