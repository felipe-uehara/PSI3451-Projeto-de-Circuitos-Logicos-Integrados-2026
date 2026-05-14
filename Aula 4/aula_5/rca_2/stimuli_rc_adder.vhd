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
	a_i, b_i	: 	out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
	c_i			:	out STD_LOGIC
	);
end stimuli_module ;

architecture test of stimuli_module  is
-- "Time" that will elapse between test vectors we submit to the component.
constant TIME_DELTA : time := 100 ns;      -- choose any value


begin

simulation : process

-- procedure for vector generation

procedure assign_input_words(constant a, b: in integer) is
begin
-- Assign values to estimuli_module´s outputs.
a_i <= std_logic_vector(to_unsigned(a,WIDTH));
b_i <= std_logic_vector(to_unsigned(b,WIDTH));

wait for TIME_DELTA;
end procedure assign_input_words;


procedure assign_carry_in (constant a: in STD_LOGIC) is
begin
-- Assign values to estimuli_module´s outputs.
c_i <= a;

wait for TIME_DELTA;
end procedure assign_carry_in;

begin

-- test vectors application
--127+53=180
assign_input_words(53, 127);
assign_carry_in('0');

--N = 13680612mod256 = 228
--N + 127 + 0 = 355
assign_input_words(228, 127);
assign_carry_in('0');

--N + 127 + 1 = 356
assign_input_words(228, 127);
assign_carry_in('1');

--M = 27
--N + M + 1 = 256
assign_input_words(228, 27);
assign_carry_in('1');

--M = 26
--N + M + 0 = 255
assign_input_words(228, 26);
assign_carry_in('1');

--outros testes
--N + 10 + 0 = 238
assign_input_words(228, 10);
assign_carry_in('0');

--N + 0 + 0 = 228
assign_input_words(228, 0);
assign_carry_in('0');
wait;
end process simulation;
end architecture test;