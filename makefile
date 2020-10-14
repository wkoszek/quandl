all: lint quandl quandl.linux quandl.test

GOLDFLAGS=-ldflags "-w -s"

quandl: *.go
	go build $(GOLDFLAGS) -o quandl *.go             # actually building stuff

lint:
	gofmt -w *.go                       # formatting of Golang according to standard
	goimports -w *.go                   # getting rid of too many imports/too few of them
	gotags *.go > tags                  # tags for easy browsing
	golint $(GOLINTFLAGS) .                           # linting (static analysis) of Go code

ci: quandl quandl-win64.exe quandl.test

quandl.test: *.go
	go test -o quandl.test -v -cover -c  # compile tests to the binary quandl.test. It doesn't run anything

quandl.linux: *.go
	GOARCH=amd64 GOOS=linux  go build $(GOLDFLAGS) -o quandl.linux *.go

quandl-win64.exe: *.go
	GOARCH=amd64 GOOS=windows go build -o quandl-win64.exe *.go

quandl-win32.exe: *.go
	GOARCH=386   GOOS=windows go build -o quandl-win32.exe *.go

t: lint quandl.test
	# We run tests and capture the coverage
	./quandl.test -test.v -test.coverprofile=cov.out

	# Show the current branch
	git branch | egrep '^\*'

	# Convert cov.out to HTML (see it on Gitlab, in build job artifacts)
	go tool cover -html=cov.out -o quandl-coverage-`git branch| awk '/^\*/{print $$2}' |tr '/-)(' '-'`-`date +%Y%m%d-%s`.html

	# Get coverage number from tests output to GitLab metric
	go tool cover -func=cov.out |awk '/total:/ { print "coverage", $$3 }' > metric-cov.txt
	cat metric-cov.txt

	# We convert coverage info to show GitLab coverage number in GitHub
	gocover-cobertura < cov.out > quandl-coverage.xml

install-tools:
	go get -u github.com/jstemmer/gotags
	go get -u golang.org/x/tools/cmd/goimports
	go get -u github.com/t-yuki/gocover-cobertura
	go get -u golang.org/x/lint/golint

d: quandl.linux
	scp /tmp/quandl_1.0.0_amd64.deb vagrant@big:
	#rsync -va --exclude vendor . big:/home/ubuntu/apps/quandl.net

s: quandl
	./quandl server

clean:
	rm -rf quandl.linux quandl quandl-win64.exe quandl-win32.exe

.PHONY: tags clean c i tags lint
