#!/bin/bash

if [ ! -d /xtf ]; then
    /init.sh
fi

exec "$CATALINA_HOME"/bin/catalina.sh run
