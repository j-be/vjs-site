#! /bin/bash

THUMBNAIL_FOLDER=thumbnails

cd img
for i in `ls gallery`
do
	echo $i
	pushd gallery/$i
	rm -rf $THUMBNAIL_FOLDER
	mkdir $THUMBNAIL_FOLDER
	cp *.jpg $THUMBNAIL_FOLDER
	pushd $THUMBNAIL_FOLDER
	for i in `ls`
	do
		echo $i
		convert $i -resize 170x $i
		convert $i -gravity Center  -crop 170x114+0+0 +repage $i
	done
	popd
	popd
done

