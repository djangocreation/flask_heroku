#!/bin/bash

# CONFIGURATION DEPUIS FABRIC
NAME="$project_name"                                  # Name of the application
PROJECTDIR=$project_root/project             # Django project directory
SOCKFILE=$project_root/run/gunicorn.sock  # we will communicte using this unix socket
USER=$project_user                        # the user to run as
GROUP=$project_user                       # the group to run as

# CONFIGURATION SUR LE SQUELETTE
NUM_WORKERS=3                                     # how many worker processes should Gunicorn spawn
WSGI_MODULE=wsgi                     # WSGI module name

# Activate the virtual environment
cd $PROJECTDIR
source ../venv/bin/activate
export PYTHONPATH=$PROJECTDIR:$PYTHONPATH

# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR

# Start your Django Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
exec ../venv/bin/gunicorn ${WSGI_MODULE}:application \
  --name $NAME \
  --workers $NUM_WORKERS \
  --user=$USER --group=$GROUP \
  --bind=unix:$SOCKFILE \
  --log-level=debug \
  --log-file=-
