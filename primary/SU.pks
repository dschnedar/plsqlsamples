CREATE OR REPLACE PACKAGE su AS
  ---------------------------------------------------------------------------------------------
  --This package is meant to demonstrate a basic Sudoku solution algorithm.
  --There isn't a way to create new Sudoku puzzles.
  ---------------------------------------------------------------------------------------------
  PROCEDURE show;
  PROCEDURE test;
  FUNCTION solve( rc INTEGER ) RETURN BOOLEAN;
END su;
/
