library ieee;
use ieee.std_logic_1164.all;


entity xilinx_mmcm_model_fsm is
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
end entity;

architecture v1 of xilinx_mmcm_model_fsm is

    component xilinx_mmcm_model_fsm_start
        port (
            SEL: in std_logic_vector (6 downto 0);
            SEL_effective: in std_logic_vector (6 downto 0);

            oDiff: out std_logic
        );
    end component;

    component xilinx_mmcm_model_fsm_logic
        port (
            iClk: in std_logic;
            iReset: in std_logic;

            iDiff: in std_logic;
            PROGDONE: in std_logic;
            iLocked: in std_logic;

            oStart: out std_logic
        );
    end component;

    component xilinx_mmcm_model_fsm_worker
        port (
            iClk: in std_logic;
            iReset: in std_logic;

            iStart: in std_logic;
            SEL: in std_logic_vector (6 downto 0);

            SEL_effective: out std_logic_vector (6 downto 0);

            PROGCLK: out std_logic;
            PROGEN: out std_logic;
            PROGDATA: out std_logic
        );
    end component;

    signal sDiff: std_logic;
    signal sStart: std_logic;
    signal SEL_effective: std_logic_vector (6 downto 0);

begin

    starter: xilinx_mmcm_model_fsm_start
        port map (
            SEL => SEL,
            SEL_effective => SEL_effective,

            oDiff => sDiff
        );

    logic: xilinx_mmcm_model_fsm_logic
        port map (
            iClk => iClk,
            iReset => iReset,

            iDiff => sDiff,
            PROGDONE => PROGDONE,
            iLocked => iLocked,

            oStart => sStart
        );

    worker: xilinx_mmcm_model_fsm_worker
        port map (
            iClk => iClk,
            iReset => iReset,

            iStart => sStart,
            SEL => SEL,

            SEL_effective => SEL_effective,

            PROGCLK => PROGCLK,
            PROGEN => PROGEN,
            PROGDATA => PROGDATA
        );

end v1;
