VERSION := 0.2.2

all: build

.PHONY: build
build:
	go build

.PHONY: format
format:
	find . -name '*.go' -exec gofmt -s -w {} +

.PHONY: check
check:
	gometalinter --deadline 10m --config gometalinter.json ./...
	go test -timeout 30s ./...

.PHONY: docs
docs:
	jsdoc -c jsdoc.json

.PHONY: container
container:
	docker build --rm --pull --no-cache -t loadimpact/k6:$(VERSION) .

.PHONY: push
push:
	docker push loadimpact/k6:$(VERSION)

# Release binaries to GitHub.
release: build
	@echo "==> Releasing"
	@goreleaser -p 1 --rm-dist -config .goreleaser.yml
	@echo "==> Complete"
.PHONY: release
