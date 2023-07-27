# cloudreve + aria2


```
docker login
docker buildx create --use --name slitazcn-builder
docker buildx build --platform linux/amd64,linux/arm/v7,linux/arm64 -t slitazcn/cloudreve:latest --push .
```