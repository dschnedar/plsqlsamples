CREATE OR REPLACE PACKAGE su AS
  ---------------------------------------------------------------------------------------------
  -- This package is meant to demonstrate a basic Sudoku solution algorithm.
  -- There isn't a way to create new Sudoku puzzles.
  -- To start salving call 
  --
  --
  --      su.new_matrix(    '    41 23' 
  --                     || ' 9       '
  --                     || '  6 9   4'
  --                     || '   86 4  '
  --                     || ' 89   65 '
  --                     || '  4 39   '
  --                     || '6   1 2  '
  --                     || '       1 '
  --                     || '15 27    '  );
  --      su.show;
  ---------------------------------------------------------------------------------------------
  g_steps INTEGER :=0; -- counts how many times solved is called
  --
  PROCEDURE show;                                     -- prints puzzle
  FUNCTION  solve( rc INTEGER ) RETURN BOOLEAN;       -- solve(1) to solve a puzzle
  PROCEDURE init_matrix;                              -- creates puzzle
  PROCEDURE new_matrix ( p_starting_str VARCHAR2 );   -- creates and initializes puzzle
  PROCEDURE test; 
  PROCEDURE test_1;
END su;
/
