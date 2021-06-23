LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY seg7_lut IS
PORT (idig: IN STD_LOGIC_VECTOR(3 DOWNTO 0);

oseg: OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END seg7_lut;
ARCHITECTURE trans OF seg7_lut IS
BEGIN
PROCESS (idig)
BEGIN
CASE idig IS
  WHEN "0001" =>oseg <= "1111001";
  WHEN "0010" =>oseg <= "0100100";
  WHEN "0011" =>oseg <= "0110000";
  WHEN "0100" =>oseg <= "0011001";
  WHEN "0101" =>oseg <= "0010010";
  WHEN "0110" =>oseg <= "0000010";
  WHEN "0111" =>oseg <= "1111000";
  WHEN "1000" =>oseg <= "0000000";
  WHEN "1001" =>oseg <= "0011000";
  WHEN "1010" =>oseg <= "0001000";
  WHEN "1011" =>oseg <= "0000011";
  WHEN "1100" =>oseg <= "1000110";
  WHEN "1101" =>oseg <= "0100001";
  WHEN "1110" =>oseg <= "0000110";
  WHEN "1111" =>oseg <= "0001110";
WHEN OTHERS =>oseg <= "1000000";
END CASE;
END PROCESS;
END trans;
