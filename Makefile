all:
	rm -rf build &>/dev/null
	rm -rf *.so &>/dev/null
	rm -rf re2.cpp &>/dev/null
	python setup.py build_ext --inplace
