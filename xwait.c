//#!/usr/bin/tcc -run

/*
 * use it to hold your X session.
 * You can either compile it, or run it through tcc using it's special shebang,
 * that's up to you, really.
 *
 * echo "exec xwait" >> ~/.xinitrc
 *
 */

#include <unistd.h>
#include <sys/wait.h>

int
main ( c, v, e )
    int c;
    char **v;
    char **e;
    {
    for( ;; )
        {
        wait( NULL );
        sleep( 1 );
        }

    return 0;
    }

/* vim: set ft=c: */
