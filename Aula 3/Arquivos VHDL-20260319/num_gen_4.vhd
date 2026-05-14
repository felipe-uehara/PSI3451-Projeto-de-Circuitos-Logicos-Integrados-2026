library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity num_gen_with_procedure is
	generic
	(
	WIDTH	: natural := 8
	);
	
	port
	(	ng_rand_zero: in  STD_LOGIC;
		ng_cte_incr	: in  STD_LOGIC;
		alu_2_ng	: in  STD_LOGIC_VECTOR (WIDTH-1 downto 0);

		ng_2_rb		: out STD_LOGIC_VECTOR (WIDTH-1 downto 0)
	);
end num_gen_with_procedure ;


architecture arch of num_gen_with_procedure is


--***********************************
--*	SIMPLIFIED FUNTION DECLARATION		*
--***********************************

procedure rand_num_p(nusp: in natural; signal res_v : out std_logic_vector(7 downto 0)) is

begin
  res_v <= std_logic_vector (to_unsigned(nusp,8)) AFTER 8 ns;
end rand_num_p;


--***********************************
--*	INTERNAL SIGNAL DECLARATIONS	*
--***********************************

	signal number_s         : unsigned(WIDTH-1 downto 0);
	SIGNAL ng_2_rb_s        : unsigned(WIDTH-1 downto 0);
	signal alu_2_ng_s       : unsigned(WIDTH-1 downto 0);
	signal rand_num			: std_logic_vector(WIDTH-1 downto 0);

begin

	--*******************************
	--*	SIGNAL ASSIGNMENTS			*
	--*******************************
		
		rand_num_p(228, rand_num);

		alu_2_ng_s		<= 	unsigned (alu_2_ng) ;


	
		number_s	<=	unsigned (rand_num) when (ng_rand_zero = '0') else	
						"00000000"	 when (ng_rand_zero = '1') else
						(others => 'X' );						
							 
		ng_2_rb_s	<=	number_s	      when (ng_cte_incr = '0') else
							alu_2_ng_s     when (ng_cte_incr = '1') else
							(others => 'X' );					
					
		ng_2_rb      <= std_logic_vector(ng_2_rb_s);
end arch;