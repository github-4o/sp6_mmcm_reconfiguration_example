library ieee;
use ieee.std_logic_1164.all;


entity xilinx_mmcm_model_fsm_logic is
    generic (
        gReset_active_lvl: std_logic := '0'
    );
    port (
        iClk: in std_logic;
        iReset: in std_logic;

        iDiff: in std_logic;
        PROGDONE: in std_logic;
        iLocked: in std_logic;

        oStart: out std_logic
    );
end entity;

architecture v1 of xilinx_mmcm_model_fsm_logic is

    type tState is (
        idle,
        start,
        wait_progdone,
        wait_locked
    );

    signal sState: tState;

begin

    process (iClk, iReset)
    begin
        if iReset = gReset_active_lvl then
            oStart <= '0';
        else
            if iClk'event and iClk = '1' then
                if sState = start then
                    oStart <= '1';
                else
                    oStart <= '0';
                end if;
            end if;
        end if;
    end process;

    process (iClk, iReset)
    begin
        if iReset = gReset_active_lvl then
            sState <= idle;
        else
            if iClk'event and iClk = '1' then
                case sState is
                    when idle =>
                        if iDiff = '1' then
                            sState <= start;
                        end if;

                    when start =>
                        sState <= wait_progdone;

                    when wait_progdone =>
                        if PROGDONE = '1' then
                            sState <= wait_locked;
                        end if;

                    when wait_locked =>
                        if iLocked = '1' then
                            sState <= idle;
                        end if;

                    when others =>
                        sState <= idle;
                end case;
            end if;
        end if;
    end process;

end v1;
