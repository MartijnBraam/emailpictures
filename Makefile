PRG_NAME=emailpictures

VALAC=valac-0.22
VALAFILES=main.vala
VALAPKGS=--pkg gtk+-3.0 --pkg gmodule-2.0
VALAOPTS=

default:
	$(VALAC) -X -DGETTEXT_PACKAGE="main" $(VALAFILES) -o $(PRG_NAME) $(VALAPKGS) $(VALAOPTS)

run:
	./$(PRG_NAME)

clean:
	rm -rf *.o $(PRG_NAME)

pot:
	xgettext --language=C --keyword=_ --escape --sort-output -o main.pot $(VALAFILES)
	xgettext --language=Glade --keyword=_ -o ui.pot *.ui
	msgcat *.pot > all.pot
