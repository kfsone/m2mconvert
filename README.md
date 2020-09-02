Movie to Move Converter
=======================

Cheap and not particularly cheerful, Dockerized video converter based on ffmpeg.

Usage
-----

m2mc.ps1 and m2mc.sh provide simple wrappers, but to use directly you need to provide an
input file and an output file, and a mount (/convert) in which to work from.

	docker run -v $PWD:/convert -input source.mov -output out.mp4

