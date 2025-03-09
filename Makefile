.PHONY: examples


CC = xelatex

WHICHCC = $(shell which $CC)
WHICHDOCKER = $(shell which docker)


EXAMPLES_DIR = examples
RESUME_DIR = examples/resume
CV_DIR = examples/cv
RESUME_SRCS = $(shell find $(RESUME_DIR) -name '*.tex')
CV_SRCS = $(shell find $(CV_DIR) -name '*.tex')

examples: $(foreach x, cv, $x.pdf)

resume.pdf: $(EXAMPLES_DIR)/resume.tex $(RESUME_SRCS)
	$(CC) -output-directory=$(EXAMPLES_DIR) $<

cv.pdf: $(EXAMPLES_DIR)/cv.tex $(CV_SRCS)
ifeq ($(WHICHCC),)
  ifeq ($(WHICHDOCKER),)
  else
	docker images |grep cv-latex || docker build -f Dockerfile -t cv-latex .
	docker run -ti -w=${PWD} -v ${PWD}:/${PWD} cv-latex $(CC) -output-directory=$(EXAMPLES_DIR) $<
  endif
endif
	#$(CC) -output-directory=$(EXAMPLES_DIR) $<

coverletter.pdf: $(EXAMPLES_DIR)/coverletter.tex
	$(CC) -output-directory=$(EXAMPLES_DIR) $<

clean:
	rm -rf $(EXAMPLES_DIR)/*.pdf
echo:
	@echo "OK"
