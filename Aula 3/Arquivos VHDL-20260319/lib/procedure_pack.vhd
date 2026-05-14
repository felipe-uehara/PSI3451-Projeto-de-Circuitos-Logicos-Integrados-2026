library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package procedure_pack is
	procedure rand_num_p(nusp: in natural; signal res_v : out std_logic_vector(7 downto 0));
end procedure_pack;


package body procedure_pack is
	procedure rand_num_p(nusp: in natural; signal res_v : out std_logic_vector(7 downto 0)) is
		begin
  			res_v <= std_logic_vector (to_unsigned(nusp,8)) AFTER 8 ns;
		end rand_num_p;
end procedure_pack;
