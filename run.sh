#!/bin/bash

set -ie

# install XTF if it is not there
if [ ! -d /xtf/style ]; then
    /init.sh
fi

exec "$CATALINA_HOME"/bin/catalina.sh run
