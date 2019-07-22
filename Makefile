test:
	THEMIS_VIM=nvim THEMIS_ARGS="-e -s --headless" themis
	THEMIS_VIM=vim THEMIS_ARGS="-e -s" themis

demo:
	# go get -u github.com/rhysd/vimwasm-try-plugin
	vimwasm-try-plugin 'notomo/vimited'

.PHONY: test
