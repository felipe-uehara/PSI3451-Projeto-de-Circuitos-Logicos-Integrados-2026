library IEEE; 
use IEEE.STD_LOGIC_1164.all; 

package wisdom_package is 
	
	type CONTROL_SELECT is
	(
	INIT_CONTR,
	GURU_CONTR
	);
  
	type RB_SEL is	(
					INIT_OUT,
					REG_GURU_OUT,
					REG_GURU_PREV_OUT
					);
	
	
	type CODE is 	(
					BLANK,
					GURU,
					DISCIPLE,
					DUO
					);

	constant BLANK_VEC		: STD_LOGIC_VECTOR(7 downto 0) := "00000001";
	constant GURU_VEC	: STD_LOGIC_VECTOR(7 downto 0) := "00000010";
	constant DISC_VEC	: STD_LOGIC_VECTOR(7 downto 0) := "00000100";
	constant DUO_VEC	: STD_LOGIC_VECTOR(7 downto 0) := "00001000";
  	   
	type CODE_BITS is array (CODE) of STD_LOGIC_VECTOR(7 downto 0);
	constant CODE_VECTORS	: CODE_BITS	:= (BLANK_VEC, GURU_VEC, DISC_VEC, DUO_VEC);
					


	type ctrl_2_dp_flags is
	record
		ng_rand_zero		: STD_LOGIC;
		ng_cte_incr		: STD_LOGIC;
		rb_init_en		: STD_LOGIC;
		rb_out_sel		: RB_SEL;
		alu_ctrl		: STD_LOGIC;
		cg_sel			: CODE;
	end record;
	
	type dp_2_ctrl_flags is
	record
		ovf_of_x		: STD_LOGIC;
		end_of_guru	: STD_LOGIC;
		ovf_of_y		: STD_LOGIC;
		duo_formed		: STD_LOGIC;
	end record;

	type disc_2_base_flags is
	record
		end_of_disc	: STD_LOGIC;
	end record;

	type base_2_mem_flags is
	record
		mem_wr_en	: STD_LOGIC;
		cg_sel			: CODE;
	end record;
	
end wisdom_package ; 




library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use work.wisdom_package.all;


entity fsm_init is 
	port
	(
	clk				: in STD_LOGIC;			--from system
	res				: in STD_LOGIC;			--from system
	start_init		: in STD_LOGIC;			--from fsm internal
	ovf_of_y		: in STD_LOGIC;			--from system
	done_init		: out STD_LOGIC; 		--to fsm internal
	flags_2_dp		: out ctrl_2_dp_flags;	--to datapath
	flags_2_mem		: out base_2_mem_flags	--to memory
	);
end fsm_init;



-- Abaixo, template de Máquina de Moore


ARCHITECTURE ARCH OF fsm_init IS
	TYPE state_type IS (ST_IDLE, ST_INIT_LOOP, ST_DONE);  -- veja quantos estados hah no seu projeto
	SIGNAL state, next_state : state_type;
	
BEGIN
	------------------------Lógica Sequencial-----------------------
	SEQ: PROCESS (res, clk)
	BEGIN
		IF (res='1') THEN
			state <= ST_IDLE;
		ELSIF Rising_Edge(clk) THEN
			state <= next_state;
		END IF;
	END PROCESS SEQ;
	-----------------------Lógica Combinacional do estado siguinte--
	COMB: PROCESS (start_init, ovf_of_y, state)  -- completar com sinais de entrada + state
	BEGIN
		CASE state IS
	-- para cada estado, preencha as condicoes para transicao de estado
			WHEN ST_IDLE =>
				IF (start_init = '1') THEN
					next_state <= ST_INIT_LOOP;
				ELSE 
					next_state <= ST_IDLE;
				END IF;

				WHEN ST_DONE =>
                -- Finaliza e retorna ao estado ocioso (ou aguarda start_init descer)
                IF (start_init = '0') THEN
                    next_state <= ST_IDLE;
                ELSE
                    next_state <= ST_DONE;
                END IF;

				WHEN OTHERS =>
                next_state <= ST_IDLE;
		END CASE;
	END PROCESS COMB;

	-----------------------Lógica Combinacional de Saídas---------------------
    SAI: PROCESS (state)
    BEGIN
        -- 1. Atribuições padrão (Evita a criação de latches indesejados)
        done_init                 <= '0';
        
        flags_2_dp.ng_rand_zero   <= '0';
        flags_2_dp.ng_cte_incr    <= '0';
        flags_2_dp.rb_init_en     <= '0';
        flags_2_dp.rb_out_sel     <= INIT_OUT;
        flags_2_dp.alu_ctrl       <= '0';
        flags_2_dp.cg_sel         <= BLANK;
        
        flags_2_mem.mem_wr_en     <= '0';
        flags_2_mem.cg_sel        <= BLANK;

        -- 2. Atribuições específicas dependentes APENAS do estado atual (Moore)
        CASE state IS
            WHEN ST_IDLE =>
                -- Nenhuma saída ativa, mantêm-se os valores padrão
                
            WHEN ST_INIT_LOOP =>
                -- Habilita escrita na memória passando o código "BLANK"
                flags_2_mem.mem_wr_en     <= '1';
                flags_2_mem.cg_sel        <= BLANK;
                
                -- Sinais para o datapath (incrementar contadores, habilitar inits)
                flags_2_dp.rb_init_en     <= '1';
                flags_2_dp.ng_cte_incr    <= '1';
                flags_2_dp.rb_out_sel     <= INIT_OUT;
                flags_2_dp.cg_sel         <= BLANK;
                
            WHEN ST_DONE =>
                -- Sinaliza que o processo de inicialização terminou
                done_init                 <= '1';
                
            WHEN OTHERS =>
                -- Valores padrão são mantidos
        END CASE;
    END PROCESS SAI;

END ARCH;