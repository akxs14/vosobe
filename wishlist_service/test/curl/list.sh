
echo "Creating product..."

curl -i \
     -H "Content-Type: application/json" \
     -X POST \
     -d '{ "title": "mylist", "public": true }' \
     http://localhost:4567/users/akxs14/lists

printf "\n\n Get akxs14's lists... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/akxs14/lists
