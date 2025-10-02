#pragma once
#include <kcstring.hpp>

int cmd_help(int argc, const ccstr_t* argv);
int cmd_echo(int argc, const ccstr_t* argv);
int cmd_exec(int argc, const ccstr_t* argv);
int cmd_cd(int argc, const ccstr_t* argv);
int cmd_ls(int argc, const ccstr_t* argv);
int cmd_tree(int argc, const ccstr_t* argv);
int cmd_cat(int argc, const ccstr_t* argv);
int cmd_mkdir(int argc, const ccstr_t* argv);
int cmd_touch(int argc, const ccstr_t* argv);
int cmd_rm(int argc, const ccstr_t* argv);
int cmd_mv(int argc, const ccstr_t* argv);
int cmd_save_output(int argc, const ccstr_t* argv);

int cmd_triple_fault(int argc, const ccstr_t* argv);
int cmd_hexdump(int argc, const ccstr_t* argv);
int cmd_memset(int argc, const ccstr_t* argv);
int cmd_readx(int argc, const ccstr_t* argv);
int cmd_writex(int argc, const ccstr_t* argv);
int cmd_readpio(int argc, const ccstr_t* argv);
int cmd_writepio(int argc, const ccstr_t* argv);
int cmd_memmap(int argc, const ccstr_t* argv);

int cmd_stacktrace(int argc, const ccstr_t* argv);
int cmd_dump_allocs(int argc, const ccstr_t* argv);

int cmd_lspci(int argc, const ccstr_t* argv);
int cmd_http_fetch(int argc, const ccstr_t* argv);

int cmd_ihd_gfx_init(int argc, const ccstr_t* argv);
int cmd_ihd_gfx_modeset(int argc, const ccstr_t* argv);
int cmd_gmbus_read(int argc, const ccstr_t* argv);
int cmd_sbi_read(int argc, const ccstr_t* argv);
int cmd_sbi_write(int argc, const ccstr_t* argv);