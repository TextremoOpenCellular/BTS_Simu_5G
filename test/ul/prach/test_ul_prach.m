clear;
clc;

% PRACH UT test
common_variables;


prach = Prach("FR1", "FDD", 0, 30, "UnrestrictedSet", 10, ...
              7);