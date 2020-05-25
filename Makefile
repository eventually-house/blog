HUGO_VERSION?=0.71

all: compile

compile:
	@hugo > /dev/null

# for more information see:
# https://gohugo.io/hosting-and-deployment/hosting-on-github/#deployment-of-project-pages-from-your-gh-pages-branch
publish: compile git-conditional-commit
	cd public
	git push origin gh-pages
	cd ..

#------------------
#-- tools
#------------------

git-conditional-commit:
	cd public
	echo $$(PWD)
	@if [ $$(git status -s | grep -c 'M\|??\|A') != "0" ]; then \
		git add --all; \
		git commit -m "commiting to gh-pages @ $$(/bin/date)"; \
	fi
	cd ..

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