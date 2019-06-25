library ieee;
use ieee.std_logic_1164.all;


entity xilinx_mmcm_model_fsm_worker is
    generic (
        gReset_active_lvl: std_logic := '0'
    );
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
end entity;

architecture v1 of xilinx_mmcm_model_fsm_worker is

    type tState is (
        idle,
        send_mult_cmd0,
        send_mult_cmd1,
        send_mult0,
        send_mult1,
        send_mult2,
        send_mult3,
        send_mult4,
        send_mult5,
        send_mult6,
        send_mult7,
        gap0,
        gap1,
        gap2,
        gap3,
        gap4,
        send_go
    );

    signal sState: tState;

    signal sCe: std_logic;

begin

    process (iClk, iReset)
    begin
        if iReset = gReset_active_lvl then
            PROGCLK <= '0';
        else
            if iClk'event and iClk = '1' then
                if sState = idle then
                    PROGCLK <= '0';
                else
                    PROGCLK <= sCe;
                end if;
            end if;
        end if;
    end process;

    process (iClk, iReset)
    begin
        if iReset = gReset_active_lvl then
            PROGEN <= '0';
        else
            if iClk'event and iClk = '1' then
                case sState is
                    when send_mult_cmd0
                        | send_mult_cmd1
                        | send_mult0
                        | send_mult1
                        | send_mult2
                        | send_mult3
                        | send_mult4
                        | send_mult5
                        | send_mult6
                        | send_mult7
                        | send_go
                    =>
                        PROGEN <= '1';
                    when others =>
                        PROGEN <= '0';
                end case;
            end if;
        end if;
    end process;

    process (iClk, iReset)
    begin
        if iReset = gReset_active_lvl then
            PROGDATA <= '0';
        else
            if iClk'event and iClk = '1' then
                if sCe = '1' then
                    case sState is
                        when idle =>
                            PROGDATA <= '0';

                        when send_mult_cmd0 =>
                            PROGDATA <= '1';

                        when send_mult_cmd1 =>
                            PROGDATA <= '1';

                        when send_mult0 =>
                            PROGDATA <= '0';

                        when send_mult1 =>
                            PROGDATA <= SEL (0);

                        when send_mult2 =>
                            PROGDATA <= SEL (1);

                        when send_mult3 =>
                            PROGDATA <= SEL (2);

                        when send_mult4 =>
                            PROGDATA <= SEL (3);

                        when send_mult5 =>
                            PROGDATA <= SEL (4);

                        when send_mult6 =>
                            PROGDATA <= SEL (5);

                        when send_mult7 =>
                            PROGDATA <= SEL (6);

                        when gap0 =>
                            PROGDATA <= '0';

                        when gap1 =>
                            PROGDATA <= '0';

                        when gap2 =>
                            PROGDATA <= '0';

                        when gap3 =>
                            PROGDATA <= '0';

                        when gap4 =>
                            PROGDATA <= '0';

                        when send_go =>
                            PROGDATA <= '0';

                    end case;
                end if;
            end if;
        end if;
    end process;

    process (iClk, iReset)
    begin
        if iReset = gReset_active_lvl then
            SEL_effective <= (SEL_effective'range => '0');
        else
            if iClk'event and iClk = '1' then
                if sState = send_go and sCe = '1' then
                    SEL_effective <= SEL;
                end if;
            end if;
        end if;
    end process;

    process (iClk, iReset)
    begin
        if iReset = gReset_active_lvl then
            sCe <= '0';
        else
            if iClk'event and iClk = '1' then
                sCe <= not sCe;
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
                        if iStart = '1' then
                            sState <= send_mult_cmd0;
                        end if;

                    when send_mult_cmd0 =>
                        if sCe = '1' then
                            sState <= send_mult_cmd1;
                        end if;

                    when send_mult_cmd1 =>
                        if sCe = '1' then
                            sState <= send_mult0;
                        end if;

                    when send_mult0 =>
                        if sCe = '1' then
                            sState <= send_mult1;
                        end if;

                    when send_mult1 =>
                        if sCe = '1' then
                            sState <= send_mult2;
                        end if;

                    when send_mult2 =>
                        if sCe = '1' then
                            sState <= send_mult3;
                        end if;

                    when send_mult3 =>
                        if sCe = '1' then
                            sState <= send_mult4;
                        end if;

                    when send_mult4 =>
                        if sCe = '1' then
                            sState <= send_mult5;
                        end if;

                    when send_mult5 =>
                        if sCe = '1' then
                            sState <= send_mult6;
                        end if;

                    when send_mult6 =>
                        if sCe = '1' then
                            sState <= send_mult7;
                        end if;

                    when send_mult7 =>
                        if sCe = '1' then
                            sState <= gap0;
                        end if;

                    when gap0 =>
                        if sCe = '1' then
                            sState <= gap1;
                        end if;

                    when gap1 =>
                        if sCe = '1' then
                            sState <= gap2;
                        end if;

                    when gap2 =>
                        if sCe = '1' then
                            sState <= gap3;
                        end if;

                    when gap3 =>
                        if sCe = '1' then
                            sState <= gap4;
                        end if;

                    when gap4 =>
                        if sCe = '1' then
                            sState <= send_go;
                        end if;

                    when send_go =>
                        if sCe = '1' then
                            sState <= idle;
                        end if;
                end case;
            end if;
        end if;
    end process;

end v1;
