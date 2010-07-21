all:
	rm -rf build &>/dev/null
	rm -rf src/*.so &>/dev/null
	rm -rf src/re2.cpp &>/dev/null
	python setup.py build_ext --inplace
