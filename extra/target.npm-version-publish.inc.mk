.PHONY: npm-preversion-publish
npm-preversion-publish:
#	allow publishing only from the master branch
	test $$($(GIT) rev-parse --abbrev-ref HEAD 2>/dev/null) = master
	$(GIT) diff-files --quiet
	$(MAKE) test


.PHONY: npm-postversion-publish
npm-postversion-publish: dist
	$(GIT) checkout -f -B dist
	$(GIT) reset --hard origin/dist || true
	$(GIT) merge --no-edit --no-ff -s recursive -X theirs @{-1}
	$(MAKE) dist
	$(GIT) add -f dist
	VSN=$$(node -e "console.log(require('./package.json').version)"); \
		$(GIT) commit --allow-empty -m $${VSN}-dist; \
		$(GIT) tag v$${VSN}-dist; \
		$(GIT) push --no-verify -f origin \
			master:master \
			dist:dist \
			v$${VSN}:refs/tags/v$${VSN} \
			v$${VSN}-dist:refs/tags/v$${VSN}-dist
	$(LS) | $(GREP) -v dist | $(XARGS) -L1 $(GIT) clean -xdf --
	$(GIT) checkout -
	$(GIT) stash pop
