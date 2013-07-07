all: *.rb *.sh *.sql *.tlf
	./abReport.sh

pdf: summary.pdf balance.pdf
	cp summary.pdf ${HOME}/Dropbox/App/Abook/Summary.pdf
	cp balance.pdf ${HOME}/Dropbox/App/Abook/Balance.pdf

clean: *.db *.sqlite3 *.pdf
	rm *.db
	rm *.sqlite3
	rm *.pdf
