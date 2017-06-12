# FLP LOG 2017: Matrix Operations
**Author**: [xdusek21](mailto:xdusek21@stud.fit.vutbr.cz) | Daniel Dušek

Application expects redirect of file contents on standard input in specific format (as can be seen in `tests/`). This file should contain matrix definitions. Application then parses input matrixes to two list of lists using DCG rules and then executes several matrix operations on single, or both of them. 

Implemented operations: matrix addition and matrix multiplication. Nothing more, despite the fact it was required by task specification.

2/8 points received. Not surprised.

Makefile allows you to run target `make run-tests` which compiles source code and runs all the tests over test data in `tests/` folder. Installed SWI-Prolog implementation required.
