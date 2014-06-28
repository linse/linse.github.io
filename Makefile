PY=python
PELICAN=pelican
PELICANOPTS=

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/output
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py

FTP_HOST=localhost
FTP_USER=anonymous
FTP_TARGET_DIR=/

SSH_HOST=localhost
SSH_PORT=22
SSH_USER=root
SSH_TARGET_DIR=/var/www

S3_BUCKET=my_s3_bucket

CLOUDFILES_USERNAME=my_rackspace_username
CLOUDFILES_API_KEY=my_rackspace_api_key
CLOUDFILES_CONTAINER=my_cloudfiles_container

DROPBOX_DIR=~/Dropbox/Public/

DEBUG ?= 0
ifeq ($(DEBUG), 1)
	PELICANOPTS += -D
endif

help:
	@echo 'Makefile for a pelican Web site                                        '
	@echo '                                                                       '
	@echo 'Usage:                                                                 '
	@echo '   make html                        (re)generate the web site          '
	@echo '   make clean                       remove the generated files         '
	@echo '   make regenerate                  regenerate files upon modification '
	@echo '   make publish                     generate using production settings '
	@echo '   make serve [PORT=8000]           serve site at http://localhost:8000'
	@echo '   make devserver [PORT=8000]       start/restart develop_server.sh    '
	@echo '   make stopserver                  stop local server                  '
	@echo '   make ssh_upload                  upload the web site via SSH        '
	@echo '   make rsync_upload                upload the web site via rsync+ssh  '
	@echo '   make dropbox_upload              upload the web site via Dropbox    '
	@echo '   make ftp_upload                  upload the web site via FTP        '
	@echo '   make s3_upload                   upload the web site via S3         '
	@echo '   make cf_upload                   upload the web site via Cloud Files'
	@echo '   make github                      upload the web site via gh-pages   '
	@echo '                                                                       '
	@echo 'Set the DEBUG variable to 1 to enable debugging, e.g. make DEBUG=1 html'
	@echo '                                                                       '

html:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

clean:
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)

regenerate:
	$(PELICAN) -r $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

serve:
ifdef PORT
	cd $(OUTPUTDIR) && $(PY) -m pelican.server $(PORT) &
	firefox http://localhost:$(PORT)
else
	cd $(OUTPUTDIR) && $(PY) -m pelican.server &
	firefox http://localhost:8000
endif

devserver:
ifdef PORT
	$(BASEDIR)/develop_server.sh restart $(PORT)
else
	$(BASEDIR)/develop_server.sh restart
endif

stopserver:
	kill -9 `cat pelican.pid`
	kill -9 `cat srv.pid`
	@echo 'Stopped Pelican and SimpleHTTPServer processes running in background.'

publish:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(PUBLISHCONF) $(PELICANOPTS)
	if test -d $(BASEDIR)/extra; then cp $(BASEDIR)/extra/* $(OUTPUTDIR)/; fi

PAGESDIR=$(INPUTDIR)/pages
DATE := $(shell date +'%Y-%m-%d %H:%M:%S')
SLUG := $(shell echo '${NAME}' | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z)
EXT ?= md

newpost:
ifdef NAME
    echo "Title: $(NAME)" >  $(INPUTDIR)/$(SLUG).$(EXT)
    echo "Slug: $(SLUG)" >> $(INPUTDIR)/$(SLUG).$(EXT)
    echo "Date: $(DATE)" >> $(INPUTDIR)/$(SLUG).$(EXT)
    echo ""              >> $(INPUTDIR)/$(SLUG).$(EXT)
    echo ""              >> $(INPUTDIR)/$(SLUG).$(EXT)
    ${EDITOR} ${INPUTDIR}/${SLUG}.${EXT} &
else
    @echo 'Variable NAME is not defined.'
    @echo 'Do make newpost NAME='"'"'Post Name'"'"
endif

editpost:
ifdef NAME
    ${EDITOR} ${INPUTDIR}/${SLUG}.${EXT} &
else
    @echo 'Variable NAME is not defined.'
    @echo 'Do make editpost NAME='"'"'Post Name'"'"
endif

newpage:
ifdef NAME
    echo "Title: $(NAME)" >  $(PAGESDIR)/$(SLUG).$(EXT)
    echo "Slug: $(SLUG)" >> $(PAGESDIR)/$(SLUG).$(EXT)
    echo ""              >> $(PAGESDIR)/$(SLUG).$(EXT)
    echo ""              >> $(PAGESDIR)/$(SLUG).$(EXT)
    ${EDITOR} ${PAGESDIR}/${SLUG}.$(EXT)
else
    @echo 'Variable NAME is not defined.'
    @echo 'Do make newpage NAME='"'"'Page Name'"'"
endif

editpage:
ifdef NAME
    ${EDITOR} ${PAGESDIR}/${SLUG}.$(EXT)
else
    @echo 'Variable NAME is not defined.'
    @echo 'Do make editpage NAME='"'"'Page Name'"'"
endif

github: publish
	git checkout source
	ghp-import $(OUTPUTDIR)
	git checkout master
	git merge --no-edit gh-pages
	git push --all
	git checkout source

.PHONY: html help clean regenerate serve devserver publish ssh_upload rsync_upload dropbox_upload ftp_upload s3_upload cf_upload github
