
# echo "Creating list..."

# curl -i \
#      -H "Content-Type: application/json" \
#      -X POST \
#      -d '{ "title": "demo_tmp", "public": false }' \
#      http://localhost:4567/users/sousou/lists

printf "\n\n Get sousou's lists... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/sousou/lists

printf "\n\n Get sousou's private lists... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/sousou/lists/private

printf "\n\n Get sousou's public lists... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/sousou/lists/public

printf "\n\n Return single list... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/sousou/lists/1

printf "\n\n Update list... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X PUT \
     -d '{ "title": "demo_updated", "public": false }' \
     http://localhost:4567/users/sousou/lists/1

# printf "\n\n Delete list... \n\n"

# curl -i \
#      -H "Content-Type: application/json" \
#      -X DELETE \
#      -d '{ }' \
#      http://localhost:4567/users/sousou/lists/3

