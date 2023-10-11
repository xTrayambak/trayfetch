all:
	nimble release

install:
	nimble release && install -Dm755 ./trayfetch /usr/bin/trayfetch
