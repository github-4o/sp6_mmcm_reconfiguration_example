library ieee;
use ieee.std_logic_1164.all;


entity xilinx_mmcm_model_fsm_start is
    port (
        SEL: in std_logic_vector (6 downto 0);
        SEL_effective: in std_logic_vector (6 downto 0);

        oDiff: out std_logic
    );
end entity;

architecture v1 of xilinx_mmcm_model_fsm_start is

begin

    oDiff <= '1' when SEL_effective /= SEL else '0';

end v1;
