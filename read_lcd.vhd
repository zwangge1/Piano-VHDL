library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;


entity read_lcd is

  port (
		 clk : IN STD_LOGIC;
	    button1 : IN STD_LOGIC;
		 button2 : IN STD_LOGIC;
		 button3 : IN STD_LOGIC;
		 button4 : IN STD_LOGIC;
	    swstartagain : IN STD_LOGIC;
	    LCD_DATA0 : OUT STD_LOGIC;
	    LCD_DATA1 : OUT STD_LOGIC;
	    LCD_DATA2 : OUT STD_LOGIC;
	    LCD_DATA3 : OUT STD_LOGIC;
	    LCD_DATA4 : OUT STD_LOGIC;
	    LCD_DATA5 : OUT STD_LOGIC;
	    LCD_DATA6 : OUT STD_LOGIC;
	    LCD_DATA7 : OUT STD_LOGIC;
	    LCD_RW : OUT STD_LOGIC;
	    LCD_EN : OUT STD_LOGIC;
	    LCD_RS : OUT STD_LOGIC;
	    LCD_ON : OUT STD_LOGIC;
	    LCD_BLON : OUT STD_LOGIC 
    );
	 
end read_lcd;

ARCHITECTURE trans OF read_lcd IS

  component accel_kx224_ctrl
    port (
    clk              : in  std_logic;
    reset            : in  std_logic;
    spi_busy         : in  std_logic;
    data_from_spi    : in  std_logic_vector(7 downto 0);
    start_spi        : out std_logic;
    spi_rw           : out std_logic;
    link_busy        : out std_logic;
    spi_addr         : out std_logic_vector(6 downto 0);
    data_to_spi      : out std_logic_vector(7 downto 0);
    out_reg_en_bus   : out std_logic;
    accel_data_ready : out std_logic
    );
  end component;
  
	SIGNAL s_buttonA: STD_LOGIC;
	SIGNAL s_buttonB: STD_LOGIC;
	SIGNAL s_buttonC: STD_LOGIC;
	SIGNAL s_buttonD: STD_LOGIC;
	SIGNAL s_buttonE: STD_LOGIC;
	SIGNAL s_buttonF: STD_LOGIC;
	SIGNAL s_buttonG: STD_LOGIC;
	SIGNAL s_buttonH: STD_LOGIC;
	SIGNAL s_button_pressed1: STD_LOGIC;
	SIGNAL s_button_pressed2: STD_LOGIC;
	SIGNAL s_button_pressed3: STD_LOGIC;
	SIGNAL s_button_pressed4: STD_LOGIC;
	SIGNAL s_slowclk : STD_LOGIC;
	SIGNAL s_slowclk_counter : STD_LOGIC_VECTOR(19 DOWNTO 0);
	TYPE etats IS (etat_rien, etat_efface, etat_efface2, etat_retour,
	etat_retour2, etat_conf, etat_conf2, etat_allume, etat_allume2, etat_mode,
	etat_mode2, etat_ecrit);
	SIGNAL s_etat_present : etats;
	SIGNAL s_etat_prochain : etats; 

	
	
	
	BEGIN
	LCD_BLON <= '0';
	LCD_ON <= '1'; 

	  PROCESS (clk)
	  
		BEGIN
		
		 IF clk'EVENT AND clk = '1' THEN
		 s_slowclk_counter <= s_slowclk_counter + 1;
		 IF s_slowclk_counter > 524287 THEN
		 s_slowclk <= '0'; 
		 ELSE
		 s_slowclk <= '1';
		 END IF;
		 END IF;
	  END PROCESS;
		 
	  PROCESS (s_slowclk)
		
		BEGIN
		
		 IF s_slowclk'EVENT AND s_slowclk = '1' THEN
		 s_buttonA <= button1;
		 s_buttonB <= s_buttonA;
		 END IF;
		 IF s_slowclk'EVENT AND s_slowclk = '1' THEN
		 s_buttonC <= button2;
		 s_buttonD <= s_buttonC;
		 END IF;
		 IF s_slowclk'EVENT AND s_slowclk = '1' THEN
		 s_buttonE <= button3;
		 s_buttonF <= s_buttonE;
		 END IF;
		 IF s_slowclk'EVENT AND s_slowclk = '1' THEN
		 s_buttonG <= button4;
		 s_buttonH <= s_buttonG;
		 END IF;
		END PROCESS;
		
			s_button_pressed1 <= s_buttonA AND NOT s_buttonB; 
			s_button_pressed2 <= s_buttonC AND NOT s_buttonD;
			s_button_pressed3 <= s_buttonE AND NOT s_buttonF;
			s_button_pressed4 <= s_buttonG AND NOT s_buttonH;
		
		PROCESS (s_slowclk)
		BEGIN
		 IF s_slowclk'EVENT AND s_slowclk = '1' THEN
		 s_etat_present <= s_etat_prochain;
		 END IF;
		END PROCESS; 
		
		
		PROCESS (s_etat_present, s_button_pressed1,s_button_pressed2,s_button_pressed3,s_button_pressed4, swstartagain)
		BEGIN
		 CASE s_etat_present IS
		 WHEN etat_rien =>
		 IF s_button_pressed1 = '1' THEN
		 s_etat_prochain <= etat_conf;
		 ELSIF swstartagain = '1' THEN
		 s_etat_prochain <= etat_efface;
		 ELSE
		 s_etat_prochain <= etat_rien;
		 END IF;
		 LCD_EN <= '0';
		 LCD_RS <='0';
		 LCD_RW <= '0';
		 LCD_DATA0 <= '0';
		 LCD_DATA1 <= '0';
		 LCD_DATA2 <= '0';
		 LCD_DATA3 <= '0';
		 LCD_DATA4 <= '0';
		 LCD_DATA5 <= '0';
		 LCD_DATA6 <= '0';
		 LCD_DATA7 <= '0';

		 WHEN etat_efface =>
		 LCD_EN <= '1';
		 LCD_RS <='0';
		 LCD_RW <= '0';
		 LCD_DATA0 <= '1';
		 LCD_DATA1 <= '0';
		 LCD_DATA2 <= '0';
		 LCD_DATA3 <= '0';
		 LCD_DATA4 <= '0';
		 LCD_DATA5 <= '0';
		 LCD_DATA6 <= '0'; 
		 LCD_DATA7 <= '0';
		 s_etat_prochain <= etat_efface2;
		 WHEN etat_efface2 =>
		 LCD_EN <= '0';
		 LCD_RS <='0';
		 LCD_RW <= '0';
		 LCD_DATA0 <= '1';
		 LCD_DATA1 <= '0';
		 LCD_DATA2 <= '0';
		 LCD_DATA3 <= '0';
		 LCD_DATA4 <= '0';
		 LCD_DATA5 <= '0';
		 LCD_DATA6 <= '0';
		 LCD_DATA7 <= '0';
		 s_etat_prochain <= etat_retour;
		 WHEN etat_retour =>
		 LCD_EN <= '1';
		 LCD_RS <='0';
		 LCD_RW <= '0';
		 LCD_DATA0 <= '0';
		 LCD_DATA1 <= '1';
		 LCD_DATA2 <= '0';
		 LCD_DATA3 <= '0';
		 LCD_DATA4 <= '0';
		 LCD_DATA5 <= '0';
		 LCD_DATA6 <= '0';
		 LCD_DATA7 <= '0';
		 s_etat_prochain <= etat_retour2;
		 WHEN etat_retour2 =>
		 LCD_EN <= '0';
		 LCD_RS <='0';
		 LCD_RW <= '0';
		 LCD_DATA0 <= '1';
		 LCD_DATA1 <= '0';
		 LCD_DATA2 <= '0';
		 LCD_DATA3 <= '0';
		 LCD_DATA4 <= '0';
		 LCD_DATA5 <= '0';
		 LCD_DATA6 <= '0';
		 LCD_DATA7 <= '0';
		 s_etat_prochain <= etat_rien;

		 WHEN etat_conf =>
		 LCD_EN <= '1';
		 LCD_RS <='0';
		 LCD_RW <= '0';
		 LCD_DATA0 <= '0';
		 LCD_DATA1 <= '0';
		 LCD_DATA2 <= '0';
		 LCD_DATA3 <= '1'; 
		 LCD_DATA4 <= '1';
		 LCD_DATA5 <= '1';
		 LCD_DATA6 <= '0';
		 LCD_DATA7 <= '0';


		 s_etat_prochain <= etat_conf2;

		 WHEN etat_conf2 =>
		 LCD_EN <= '0';
		 LCD_RS <='0';
		 LCD_RW <= '0';
		 LCD_DATA0 <= '0';
		 LCD_DATA1 <= '0';
		 LCD_DATA2 <= '0';
		 LCD_DATA3 <= '0';
		 LCD_DATA4 <= '1';
		 LCD_DATA5 <= '1';
		 LCD_DATA6 <= '0';
		 LCD_DATA7 <= '0';


		 s_etat_prochain <= etat_allume;
		 WHEN etat_allume =>
		 LCD_EN <= '1';
		 LCD_RS <='0';
		 LCD_RW <= '0';
		 LCD_DATA0 <= '0';
		 LCD_DATA1 <= '1';
		 LCD_DATA2 <= '1';
		 LCD_DATA3 <= '1';
		 LCD_DATA4 <= '0';
		 LCD_DATA5 <= '0';
		 LCD_DATA6 <= '0';
		 LCD_DATA7 <= '0';

		 s_etat_prochain <= etat_allume2;
		 WHEN etat_allume2 =>
		 LCD_EN <= '0';
		 LCD_RS <='0';
		 LCD_RW <= '0';
		 LCD_DATA0 <= '0';
		 LCD_DATA1 <= '1';
		 LCD_DATA2 <= '1';
		 LCD_DATA3 <= '1';
		 LCD_DATA4 <= '0';
		 LCD_DATA5 <= '0';
		 LCD_DATA6 <= '0';
		 LCD_DATA7 <= '0';

		 s_etat_prochain <= etat_mode;
		 WHEN etat_mode =>
		 
		 LCD_EN <= '1';
		 LCD_RS <='0';
		 LCD_RW <= '0';
		 LCD_DATA0 <= '0';
		 LCD_DATA1 <= '1';
		 LCD_DATA2 <= '1';
		 LCD_DATA3 <= '0';
		 LCD_DATA4 <= '0';
		 LCD_DATA5 <= '0';
		 LCD_DATA6 <= '0';
		 LCD_DATA7 <= '0';


		 s_etat_prochain <= etat_mode2;

		 WHEN etat_mode2 =>

		 LCD_EN <= '0';
		 LCD_RS <='0';
		 LCD_RW <= '0';
		 LCD_DATA0 <= '0';
		 LCD_DATA1 <= '1';
		 LCD_DATA2 <= '1';
		 LCD_DATA3 <= '0';
		 LCD_DATA4 <= '0';
		 LCD_DATA5 <= '0';
		 LCD_DATA6 <= '0';
		 LCD_DATA7 <= '0';


		 s_etat_prochain <= etat_ecrit;

		 WHEN etat_ecrit =>

		 LCD_EN <= '1';
		 LCD_RS <='1';
		 LCD_RW <= '0';
		 LCD_DATA0 <= '1';
		 LCD_DATA1 <= '0';
		 LCD_DATA2 <= '0';
		 LCD_DATA3 <= '0';
		 LCD_DATA4 <= '0';
		 LCD_DATA5 <= '0';
		 LCD_DATA6 <= '1';
		 LCD_DATA7 <= '0';


		 s_etat_prochain <= etat_rien;
		 END CASE;
		END PROCESS;
		END;