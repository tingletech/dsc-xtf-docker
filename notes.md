

## fix date skew (for AWS)

```
boot2docker ssh sudo date -u -D %Y%m%dT%T --set="$(date -u +%Y%m%dT%T)"
```

## launch the docker image

```
docker run --rm -i -t -e XTF_INDEX_TAR=s3://xxx [image]
```
