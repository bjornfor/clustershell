#!/bin/sh

if [ -z "$2" ]; then
    echo "usage: $0 <version> <el5|fc11>"
    exit 1
fi


VERS=$1
DIST=$2

case $DIST in
    el5)
        VIM_VERS=70
        ;;
    fc11)
        VIM_VERS=72
        ;;
    *)
        echo "unsupported dist: $DIST"
        exit 1
esac

DIST=".$DIST"

PKGNAME=clustershell-$VERS

TMPDIR=/tmp/clustershell-build/$PKGNAME
rm -vrf /tmp/clustershell-build

mkdir -vp "$TMPDIR/lib/ClusterShell"
mkdir -vp "$TMPDIR/lib/ClusterShell/Engine"
mkdir -vp "$TMPDIR/lib/ClusterShell/Worker"
mkdir -vp "$TMPDIR/scripts"
mkdir -vp "$TMPDIR/conf"
mkdir -vp "$TMPDIR"/doc/man/{man1,man5}
mkdir -vp "$TMPDIR"/doc/extras/vim/{ftdetect,syntax}

cp -v clustershell.spec setup.cfg setup.py "$TMPDIR/"
cp -v LICENSE README "$TMPDIR/"
cp -v lib/ClusterShell/*.py "$TMPDIR/lib/ClusterShell"
cp -v lib/ClusterShell/Engine/*.py "$TMPDIR/lib/ClusterShell/Engine/"
cp -v lib/ClusterShell/Worker/*.py "$TMPDIR/lib/ClusterShell/Worker/"
cp -v scripts/clush.py "$TMPDIR/scripts/"
cp -v scripts/nodeset.py "$TMPDIR/scripts/"
cp -v conf/clush.conf "$TMPDIR/conf/"
cp -v doc/nodeset.py "$TMPDIR/scripts/"
cp -v doc/man/man1/clush.1 "$TMPDIR/doc/man/man1/"
cp -v doc/man/man1/nodeset.1 "$TMPDIR/doc/man/man1/"
cp -v doc/man/man5/clush.conf.5 "$TMPDIR/doc/man/man5/"
cp -v doc/extras/vim/ftdetect/clush.vim "$TMPDIR/doc/extras/vim/ftdetect/"
cp -v doc/extras/vim/syntax/clush.vim "$TMPDIR/doc/extras/vim/syntax/"

cd "$TMPDIR/.."

tar -czf $PKGNAME.tar.gz $PKGNAME
rpmbuild -ta --define "version $VERS" --define "dist $DIST" --define "vim_version $VIM_VERS" $PKGNAME.tar.gz

