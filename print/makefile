all: *.rb *.sh *.sql *.tlf
	./abReport.sh

pdf: summary.pdf balance.pdf
	cp summary.pdf ${HOME}/Dropbox/App/Abook/Summary.pdf
	cp balance.pdf ${HOME}/Dropbox/App/Abook/Balance.pdf

open: summary.pdf balance.pdf
	open summary.pdf
	open balance.pdf

clean: *.sqlite3 *.pdf
	rm *.sqlite3
	rm *.pdf
