# FIT VUT, FLP - Operace s maticemi
*Školní projekty do předmětu FLP (Funkcionální a Logické Programování), Fakulta Informačních Technologií, Vysoké Učení Technické Brno.*

**Author**: [xdusek21](mailto:xdusek21@stud.fit.vutbr.cz) | Daniel Dušek

Aplikace na svém vstupu přijímá pomocí přesměrování soubor odpovídající struktury (k nahlédnutí ve složce `tests/`), v němž očekává zapsané matice. Nad těmito maticemi pak provede sérii operací - v odevzdané implementované verzi pouze sčítání a násobení matice A maticí B.

Aplikace je schopna rozpoznat zda je možné matice mezi sebou násobit a sčítat. Pokud ne, vypíše na výstup řetězec `false`.

Pro naparsování zápisu ze standardního vstupu je využito knihovny dcg a jejího modulu basics, které jsou společně dostupné v instalacích swi-prologu.

Přiložený Makefile umožňuje spuštění cíle `make run-tests`, který program zkompiluje a spustí nad všemi dodanými vstupy v adresáří `tests/`.
