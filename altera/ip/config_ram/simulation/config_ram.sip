set_global_assignment -entity "config_ram" -library "lib_config_ram" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "config_ram" -library "lib_config_ram" -name IP_TOOL_VERSION "16.1"
set_global_assignment -entity "config_ram" -library "lib_config_ram" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_config_ram" -name SPD_FILE [file join $::quartus(sip_path) "../config_ram.spd"]
set_global_assignment -library "lib_config_ram" -name MISC_FILE [file join $::quartus(sip_path) "../../config_ram.qsys"]

set_global_assignment -library "lib_config_ram" -name MISC_FILE [file join $::quartus(sip_path) "config_ram.v"]
set_global_assignment -library "lib_config_ram" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_onchip_flash_util.v"]
set_global_assignment -library "lib_config_ram" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_onchip_flash.v"]
set_global_assignment -library "lib_config_ram" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_onchip_flash_avmm_data_controller.v"]
set_global_assignment -library "lib_config_ram" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_onchip_flash_avmm_csr_controller.v"]
