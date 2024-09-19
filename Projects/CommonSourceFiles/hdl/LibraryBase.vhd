-- Copyright (c) 2024 Vector Informatik GmbH  

-- Permission is hereby granted, free of charge, to any person obtaining  
-- a copy of this software and associated documentation files (the  
-- "Software"), to deal in the Software without restriction, including  
-- without limitation the rights to use, copy, modify, merge, publish,  
-- distribute, sublicense, and/or sell copies of the Software, and to  
-- permit persons to whom the Software is furnished to do so, subject to  
-- the following conditions:  
   
-- The above copyright notice and this permission notice shall be  
-- included in all copies or substantial portions of the Software.  
   
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,  
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF  
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND  
-- NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE  
-- LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION  
-- OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION  
-- WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.  


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.NUMERIC_STD.ALL;


PACKAGE LibraryBase IS

  CONSTANT c_reset_active : std_logic                    := '1';
  --
  CONSTANT c_RisingEdge   : std_logic_vector(1 DOWNTO 0) := "01";
  CONSTANT c_FallingEdge  : std_logic_vector(1 DOWNTO 0) := "10";
  --
  TYPE t_ArrayVector IS ARRAY (natural RANGE <>) OF std_logic_vector;
  TYPE t_ArrayVector3D IS ARRAY (natural RANGE <>) OF t_ArrayVector;
  --
  TYPE t_ArrayLogic IS ARRAY (natural RANGE <>) OF std_logic;
  TYPE t_ArrayLogic3D IS ARRAY (natural RANGE <>) OF t_ArrayLogic;
  --
  TYPE t_ArrayNatural IS ARRAY (natural RANGE <>) OF natural;
  TYPE t_ArrayNatural3D IS ARRAY (natural RANGE <>) OF t_ArrayNatural;
  --
  TYPE t_ArrayUnsigned IS ARRAY (natural RANGE <>) OF unsigned;
  TYPE t_ArrayUnsigned3D IS ARRAY (natural RANGE <>) OF t_ArrayUnsigned;
  --
  TYPE t_ArraySigned IS ARRAY (natural RANGE <>) OF signed;
  TYPE t_ArraySigned3D IS ARRAY (natural RANGE <>) OF t_ArraySigned;
  --
  TYPE t_ArrayString IS ARRAY (natural RANGE <>) OF string;
  TYPE t_ArrayString3D IS ARRAY (natural RANGE <>) OF t_ArrayString;
  --
  TYPE t_ArrayInteger IS ARRAY (natural RANGE <>) OF integer;
  TYPE t_ArrayInteger3D IS ARRAY (natural RANGE <>) OF t_ArrayInteger;

END LibraryBase;
