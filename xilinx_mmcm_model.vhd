library ieee;
use ieee.std_logic_1164.all;


entity xilinx_mmcm_model is
    port (
        iReset: in std_logic;
        CLK_IN: in std_logic;
        SEL: in std_logic_vector (6 downto 0);
        PLL_EN: in std_logic; -- active '1'
        CLK_OUT: out std_logic
    );
end entity;

architecture v1 of xilinx_mmcm_model is

    component xilinx_mmcm_model_fsm
        port (
            iClk: in std_logic;
            iReset: in std_logic;

            SEL: in std_logic_vector (6 downto 0);

            PROGCLK: out std_logic;
            PROGEN: out std_logic;
            PROGDATA: out std_logic;
            PROGDONE: in std_logic;

            iLocked: in std_logic
        );
    end component;

    component pll
        port (
            CLK_IN1           : in     std_logic;
            -- Clock out ports
            CLK_OUT1          : out    std_logic;
            -- Dynamic reconfiguration ports
            PROGCLK           : in     std_logic;
            PROGEN            : in     std_logic;
            PROGDATA          : in     std_logic;
            PROGDONE          : out    std_logic;
            -- Status and control signals
            RESET             : in     std_logic;
            LOCKED            : out    std_logic
        );
    end component;

    signal sReset: std_logic;
    signal sLocked: std_logic;

    signal PROGCLK: std_logic;
    signal PROGEN: std_logic;
    signal PROGDATA: std_logic;
    signal PROGDONE: std_logic;

begin

    sReset <= not PLL_EN;

    fsm: xilinx_mmcm_model_fsm
        port map (
            iClk => CLK_IN,
            iReset => iReset,

            SEL => SEL,

            PROGCLK => PROGCLK,
            PROGEN => PROGEN,
            PROGDATA => PROGDATA,
            PROGDONE => PROGDONE,

            iLocked => sLocked
        );

    pll_inst: pll
        port map (
            CLK_IN1 => CLK_IN,
            -- Clock out ports
            CLK_OUT1 => CLK_OUT,
            -- Dynamic reconfiguration ports
            PROGCLK => PROGCLK,
            PROGEN => PROGEN,
            PROGDATA => PROGDATA,
            PROGDONE => PROGDONE,
            -- Status and control signals
            RESET => sReset,
            LOCKED => sLocked
        );

end v1;
