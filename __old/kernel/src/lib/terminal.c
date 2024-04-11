#include <inttypes.h>
#include <sys/kstdio.h>
#include <sys/kstdlib.h>
#include <sys/keyboard.h>
#include <lib/kstring.h>
#include <lib/textbuffer.h>
#include <lib/fat.h>
#include <lib/terminal.h>

static fat_file root_dir;
static fat_file working_dir;
static fat_file dirFiles[32];
static TextBuffer termBuffer;

typedef struct {
    const char* name;
    int(*fn)(int argc, char** argv);
} command_name;

int cmd_ls(int argc, char** argv) {
    const char* monthNamesShort[13] = {
        "NUL",
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
    };

    char flag_a = 0;
    char flag_l = 0;
    for(int i = 1; i < argc; i++) {
        if(*argv[i] != '-') continue;
        for (int j = 1; argv[i][j]; j++) {
            if (argv[i][j] == 'a') flag_a = 1;
            else if (argv[i][j] == 'l') flag_l = 1;
        }
    }
    
    int nFiles = enum_dir(working_dir, dirFiles);
    if (flag_l) putstr(" Total Size |   Created    |   Modified   | Cluster  | Name\r\n");
    for (int i = 0; i < nFiles; i++) {
        if (dirFiles[i].entry->flags & FAT_ATTRIB_VOL_ID) continue;
        if ((dirFiles[i].entry->flags & FAT_ATTRIB_HIDDEN) && !flag_a) continue;
        if (flag_l) {
            printf(" %010i | %s %02i %02i:%02i | %s %02i %02i:%02i | %08x | %s\r\n", dirFiles[i].entry->file_size, 
            monthNamesShort[dirFiles[i].entry->creation_date.month], dirFiles[i].entry->creation_date.day, dirFiles[i].entry->creation_time.hour, dirFiles[i].entry->creation_time.minute,
            monthNamesShort[dirFiles[i].entry->modified_date.month], dirFiles[i].entry->modified_date.day, dirFiles[i].entry->modified_time.hour, dirFiles[i].entry->modified_time.minute,
            ((uint32_t)dirFiles[i].entry->cluster_high << 16) | dirFiles[i].entry->cluster_low, dirFiles[i].filename);
        }
        else printf("%s ", dirFiles[i].filename);
    }
    if (!flag_l) putstr("\r\n");
    return 0;
}
int cmd_cd(int argc, char** argv) {
    if (argc == 1) {
        working_dir = root_dir;
        return 0;
    }
    int nFiles = enum_dir(working_dir, dirFiles);
    for (int i = 0; i < nFiles; i++) {
        if (streql(dirFiles[i].filename, argv[1])) {
            if (!(dirFiles[i].entry->flags & FAT_ATTRIB_DIR)) {
                putstr("File is not a directory.\r\n");
                return -1;
            }

            working_dir = dirFiles[i];
            uint32_t cluster = ((uint32_t)working_dir.entry->cluster_high << 16) | working_dir.entry->cluster_low;
            working_dir.dataPtr = get_cluster_addr(cluster);
            read_file(working_dir, working_dir.dataPtr, working_dir.entry->file_size);
            return 0;
        }
    }
    putstr("Directory not found.\r\n");
    return -1;
}
int cmd_rm(int argc, char** argv) {
    if (argc == 1) {
        printf("No input files.\r\n");
        return -1;
    }
    int nFiles = enum_dir(working_dir, dirFiles);
    for (int j = 1; j < argc; j++) {
        int i;
        for (i = 0; i < nFiles; i++) {
            if (streql(dirFiles[i].filename, argv[j])) {
                delete_file(dirFiles[i]);
                break;
            }
        }
        if (i == nFiles)
            printf("File not found: %s\r\n", argv[j]);
    }
    return 0;
}
int cmd_mkdir(int argc, char** argv) {
    if (argc == 1) {
        printf("No input files.\r\n");
        return -1;
    }
    for (int j = 1; j < argc; j++) {
        create_directory(working_dir, argv[j], 0);
    }
    return 0;
}
int cmd_touch(int argc, char** argv) {
    if (argc == 1) {
        printf("No input files.\r\n");
        return -1;
    }
    for (int j = 1; j < argc; j++) {
        create_file(working_dir, argv[j], FAT_ATTRIB_ARCHIVE, 0);
    }
    return 0;
}

#define NCOMMANDS 5
command_name commands[NCOMMANDS] = {
    {"ls", &cmd_ls},
    {"cd", &cmd_cd},
    {"rm", &cmd_rm},
    {"mkdir", &cmd_mkdir},
    {"touch", &cmd_touch},
};

void terminal_init(fat_file rootDir) {
    root_dir = rootDir;
    working_dir = root_dir;

    buffer_init(&termBuffer, (char*)0x400000, (TextRegion){{78, 1}, {2, 24}, 0, 78});
    termBuffer.flags |= TEXTBUFFER_LINELOCK;
    setcharp('>', 0, 24);
}
void terminal_input_loop(void) {
    while (1) {
        if (keyboardInput.popIdx == keyboardInput.pushIdx) continue;
        uint8_t key = keyboardInput.loopqueue[keyboardInput.popIdx];
        keyboardInput.popIdx = (keyboardInput.popIdx + 1) % 256;
        if (update_modifiers(key)) continue;
        if (key & 0x80) continue;
        if (key == 0x1C) {
            termBuffer.buffer[termBuffer.bufferLen - 1] = 0;
            putstr(termBuffer.buffer);
            putstr("\r\n");
            char buf2[78];
            strcpy(buf2, termBuffer.buffer);
            buffer_wipe(&termBuffer);
            buffer_display(&termBuffer);
            terminal_exec(buf2);
            continue;
        }
        if (!buffer_nav(&termBuffer, key))
            buffer_putkey(&termBuffer, key);
        buffer_display(&termBuffer);
    }
}
void terminal_exec(char* cmd) {
    int argc = 0;
    char* argv[10];
    int last = 0;
    for (int i = 0; cmd[i]; i++) {
        if (cmd[i] == ' ') {
            argv[argc++] = &cmd[last];
            cmd[i] = 0;
            last = i + 1;
            continue;
        }
    }
    argv[argc++] = &cmd[last];

    for (int i = 0; i < NCOMMANDS; i++) {
        if (streql(argv[0], (char*)commands[i].name)) {
            commands[i].fn(argc, argv);
            return;
        }
    }
    putstr("Command not found.\r\n");
}
