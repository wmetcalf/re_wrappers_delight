install:
	python3 setup.py install --user

test: install
	pytest --doctest-glob='*.txt'

install2:
	python2 setup.py install --user

test2: install2
	python2 -m pytest --doctest-glob='*.txt'

clean:
	rm -rf build pyre2.egg-info &>/dev/null
	rm -f *.so src/*.so src/re2.cpp src/*.html &>/dev/null

distclean: clean
	rm -rf .tox/ dist/ .pytest_cache/

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
