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

int cmd_stacktrace(int argc, const ccstr_t* argv);
int cmd_dump_allocs(int argc, const ccstr_t* argv);