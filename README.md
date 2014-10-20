`Dockerfile` and other files for running OAC/Calisphere’s XTF in
AWS elastic beanstalk

# notes

## build docker image locally

```
docker build -t tag .
```

## fix date skew (for AWS)

```
boot2docker ssh sudo date -u -D %Y%m%dT%T --set="$(date -u +%Y%m%dT%T)"
```

## launch the docker image

when testing

```
docker run --rm -p 8080:8080 --env-file file tag
```

in `file` set:
```
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
XTF_LAYOUTS=s3://.../xtf-includes-layouts-sections.tar.gz
XTF_INDEX_TAR=s3://.../indexes/...tar
```

XTF should then be running on `http://192.168.59.103:8080/xtf/search`

## clean up

```
docker rm $(docker ps -aq)
docker rmi $(docker images --filter dangling=true --quiet)
```

# License

Copyright (c) 2014, Regents of the University of California

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

 - Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
 - Neither the name of the University of California nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

