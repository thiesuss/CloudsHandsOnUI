docker run --rm -v %cd%:/local openapitools/openapi-generator-cli generate -i /local/customer.yaml -g dart -o /local/customerapi/dart-client --additional-properties=pubName=customerapi
docker run --rm -v %cd%:/local openapitools/openapi-generator-cli generate -i /local/internal.yaml -g dart -o /local/internalapi/dart-client --additional-properties=pubName=internalapi
