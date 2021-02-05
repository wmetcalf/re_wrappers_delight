install:
	python3 setup.py install --user

test: install
	pytest --doctest-glob='*.txt'

install2:
	python2 setup.py install --user

test2: install2
	python2 -m pytest --doctest-glob='*.txt'

clean:
	rm -rf build &>/dev/null
	rm -rf src/*.so src/*.html &>/dev/null
	rm -rf re2.so tests/re2.so &>/dev/null
	rm -rf src/re2.cpp &>/dev/null

valgrind:
	python3.5-dbg setup.py install --user && \
	(cd tests && valgrind --tool=memcheck --suppressions=../valgrind-python.supp \
	--leak-check=full --show-leak-kinds=definite \
	python3.5-dbg test_re.py)

valgrind2:
	python3.5-dbg setup.py install --user && \
	(cd tests && valgrind --tool=memcheck --suppressions=../valgrind-python.supp \
	--leak-check=full --show-leak-kinds=definite \
	python3.5-dbg re2_test.py)
