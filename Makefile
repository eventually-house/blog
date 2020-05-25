HUGO_VERSION?=0.71

all: compile

reset:
	rm -rf public
	mkdir public
	git worktree prune
	rm -rf .git/worktrees/public/
	git worktree add -B gh-pages public origin/gh-pages
	rm -rf public/*

compile: reset
	@hugo > /dev/null

# for more information see:
# https://gohugo.io/hosting-and-deployment/hosting-on-github/#deployment-of-project-pages-from-your-gh-pages-branch
publish: compile git-conditional-commit
	cd public && \
	git push origin gh-pages

#------------------
#-- tools
#------------------

git-conditional-commit:
	cd $(PWD)/public && \
	if [ $$(git status -s | grep -c 'M\|??\|A') != "0" ]; then \
		git add --all; \
		git commit -m "commiting to gh-pages @ $$(/bin/date)"; \
	fi

# used in CI in order to not duplicate the specification of GO_VERSION
hugo-version:
	@echo $(HUGO_VERSION)

validate-hugo-version:
	@if [ $$(hugo version | awk '{print substr($$5, 2, 4)}') != "$(HUGO_VERSION)" ]; then \
		echo "==================================================================="; \
		echo "Must be using Hugo $(HUGO_VERSION)"; \
		echo "Please install the correct feature version to compile this project."; \
		echo "==================================================================="; \
		exit 1; \
	fi