all:
	rm -rf build &>/dev/null
	rm -rf src/*.so &>/dev/null
	rm -rf re2.so &>/dev/null
	rm -rf src/re2.cpp &>/dev/null
	python setup.py --cython build_ext --inplace

test: all
	(cd tests && python test.py)
