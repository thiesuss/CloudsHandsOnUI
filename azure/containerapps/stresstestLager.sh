url=$1
method=POST
body='{"name": "Apfel", "price": 1.12, "stock": 30}'
while :
do
    echo $(curl -X "$method" -d "$body" -H "Content-Type: application/json" "$url")
done