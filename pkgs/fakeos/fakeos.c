#define _GNU_SOURCE
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <dlfcn.h>
#include <basedir_fs.h>

int open(const char *path, int oflag) {
    char *realpath = NULL, *fakepath = NULL;
    int ret;
    int (*nopen)(const char *path, int oflag);

    if (strcmp(path, "/etc/os-release")) {
        goto out;
    }

    fakepath = xdgConfigFind("fakeos/os-release", NULL);
    if (fakepath == NULL) {
        goto out;
    }

    realpath = fakepath;

 out:
    nopen = dlsym(RTLD_NEXT, "open");
    ret = nopen(realpath, oflag);
    free(fakepath);
    return ret;
}
