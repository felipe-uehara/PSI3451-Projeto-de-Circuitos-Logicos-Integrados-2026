library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stimuli_module is
	generic
	(
	WIDTH	: natural := 8
	);
	
	port
	(
	one_op		     : out STD_LOGIC_VECTOR(WIDTH-1 downto 0); 
	rb_op	: 	out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
	alu_ctrl         : out STD_LOGIC      
	);
	
end stimuli_module ;

architecture test of stimuli_module  is
-- "Time" that will elapse between test vectors we submit to the component.
constant TIME_DELTA : time := 100 ns;      -- choose any value

 
begin
	simulation : process -- procedure for vector generation (as input, one_op ,  rb_op and alu_ctrl)
		begin
			--teste 1: seleção do mux 
			one_op <= std_logic_vector(to_unsigned(228,WIDTH));
			rb_op <= std_logic_vector(to_unsigned(0,WIDTH));
			alu_ctrl <= '1'; --soma selecionada
			wait for TIME_DELTA;

			--teste 2: seleção do mux 
			alu_ctrl <= '0'; --rb_op selecionada
			wait for TIME_DELTA;


			teste2 : for incremento in 1 to 28 loop 
				one_op <= std_logic_vector(to_unsigned(228+incremento,WIDTH));
				alu_ctrl <= '1';
				wait for TIME_DELTA;

				alu_ctrl <= '0';
				wait for TIME_DELTA;
			end loop teste2;
			wait;
		end process simulation;
end architecture test;