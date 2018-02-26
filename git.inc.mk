GIT_BRANCH = $(shell cd $(TOP) && git rev-parse --abbrev-ref HEAD 2>/dev/null)
GIT_BRANCH_SHORT = $(shell basename $(GIT_BRANCH))
GIT_HASH = $(shell cd $(TOP) && git rev-parse HEAD 2>/dev/null)
GIT_HASH_SHORT = $(shell cd $(TOP) && git rev-parse --short HEAD 2>/dev/null)
GIT_REMOTE = $(shell git config branch.$(GIT_BRANCH).remote 2>/dev/null)
GIT_ROOT = $(shell cd $(TOP) && git rev-parse --show-toplevel 2>/dev/null)
GIT_TAGS = $(shell git describe --exact-match --tags HEAD 2>/dev/null)

TRAVIS ?=

ifeq (true,$(TRAVIS))
GIT_BRANCH = $(TRAVIS_BRANCH)
endif

$(foreach VAR,GIT_BRANCH GIT_BRANCH_SHORT GIT_HASH GIT_HASH_SHORT GIT_REMOTE GIT_ROOT GIT_TAGS,$(call make-lazy,$(VAR)))
