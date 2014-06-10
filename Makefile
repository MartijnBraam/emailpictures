PRG_NAME=emailpictures

VALAC=valac-0.22
VALAFILES=main.vala
VALAPKGS=--pkg gtk+-3.0
VALAOPTS=

default:
	$(VALAC) $(VALAFILES) -o $(PRG_NAME) $(VALAPKGS) $(VALAOPTS)

run:
	./$(PRG_NAME)

clean:
	rm -rf *.o $(PRG_NAME)
