library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_rc_adder is

GENERIC (WIDTH: natural :=8);

end tb_rc_adder;

architecture test of tb_rc_adder is

component stimuli_module 
	generic
	(
	WIDTH	: natural := 8
	);
	
	port
	(
	a_i, b_i	: 	out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
	c_i			:	out STD_LOGIC
	);
end component ;

component rc_adder_2 
	generic
	(
	WIDTH : integer := 8
	);
	
	port
	(
	a_i, b_i	: 	in STD_LOGIC_VECTOR(WIDTH-1 downto 0);
	c_i			:	in STD_LOGIC;
	z_out 		: 	out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
	c_o			:	out STD_LOGIC
	);
end component ;

	signal a_i_s, b_i_s, z_o_s : STD_LOGIC_VECTOR(WIDTH-1 downto 0); 
	signal c_i_s, c_o_s : STD_LOGIC;

begin

-- Instantiate DUT
	dut : rc_adder_2
		generic map(WIDTH => WIDTH)
		port map(a_i	 		=> a_i_s, 
				b_i 			=> b_i_s,
				c_i 			=> c_i_s,
				z_out 			=> z_o_s,
				c_o 			=> c_o_s);

-- Instantiate test module
	test : stimuli_module
		generic map(WIDTH => WIDTH)
		port map(a_i	 		=> a_i_s, 
				b_i 			=> b_i_s,
				c_i 			=> c_i_s);


end architecture test;

------------------------------------------------------------------------------------
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
--N + M + 1 = 255
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
-----------------------------------------------------------------------------------------------
Library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity rc_adder_2 is
	generic
	(
	WIDTH	: natural := 8
	);
	port
	(
	a_i, b_i		:	in STD_LOGIC_VECTOR (WIDTH-1 downto 0); --8bits
	c_i				:	in STD_LOGIC;

	z_out			:	out STD_LOGIC_VECTOR (WIDTH-1 downto 0);
	c_o				:	out STD_LOGIC
	);
	
end rc_adder_2;


architecture structural of rc_adder_2 is


	COMPONENT full_adder_1 
		port ( a_in, b_in, c_in		:	in STD_LOGIC;
				z_out, c_out		:	out STD_LOGIC);
	END COMPONENT;
	
  
  
signal carry	: STD_LOGIC_VECTOR (WIDTH-1 downto 0);  -- auxiliary signal carry(x) means carry_out of stage x

begin

-- a seguir, template e versao incompleta

-- FOR generate para todos os bits

	G_ALL : FOR N IN WIDTH-1 DOWNTO 0 GENERATE
	
--      IF generate para caso LSB- codificar para N=0
		G_LSB: IF (N = 0) generate
			fa_LSB: full_adder_1 port map(	a_in => a_i(N), 
											b_in => b_i(N), 
											c_in => '0', 
											z_out => z_out(N), 
											c_out => carry(N));
		end generate G_LSB;
--		fechar IF 



--      IF generate para caso MSB- codificar para N=WIDTH-1=7
		G_MSB: IF(N = WIDTH-1) generate
			fa_MSB: full_adder_1 port map(	a_in => a_i(N), 
											b_in => b_i(N), 
											c_in => carry(N-1), 
											z_out => z_out(N), 
											c_out => carry(N));
		end generate G_MSB;
--		fechar IF 

		
--		IF generate para demais casos
		
		G_CENTRAL : IF (N < WIDTH-1 AND N > 0) GENERATE -- para n=6,5,4,3,2,1
			fa_central : full_adder_1 port map(	a_in => a_i(N), 
											b_in => b_i(N), 
											c_in => carry(N-1), 
											z_out => z_out(N), 
											c_out => carry(N));
			--full_adder_1 PORT MAP (a_i(N), b_i(N), carry (N-1), z_out(N), carry (N)); 
		END GENERATE G_CENTRAL;
				
--		fechar IF 
		
	END GENERATE G_ALL;

-- fechar FOR
	c_o <= carry(WIDTH-1);

end structural;

-------------------------------------------------------------------------------------
Library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity full_adder_1 is
	port
	(
	a_in, b_in, c_in		:	in STD_LOGIC;
	z_out, c_out		:	out STD_LOGIC
	);
	
end full_adder_1;



architecture dataflow of full_adder_1 is

signal aux_xor, aux_and_1, aux_and_2, aux_and_3	: STD_LOGIC;

begin

	z_out <= aux_xor xor c_in AFTER 4 ns;
     aux_xor <= a_in xor b_in AFTER 4 ns;
     aux_and_1 <= a_in and b_in AFTER 3 ns; 
     aux_and_2 <= a_in and c_in AFTER 3 ns; 
	c_out <= aux_and_1 or aux_and_2 or aux_and_3 AFTER 5 ns; 
	aux_and_3 <= b_in and c_in AFTER 3 ns; 
	
end dataflow;