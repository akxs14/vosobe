
# echo "Creating product..."

# curl -i \
#      -H "Content-Type: application/json" \
#      -X POST \
#      -d '{ "title": "product_3", "url": "www.miumiu.com" }' \
#      http://localhost:4567/users/sousou/lists/1/products


printf "\n\n Get sousou's list 1 products... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/sousou/lists/1/products


printf "\n\n Return single product... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/sousou/lists/1/products/1


# printf "\n\n Delete product... \n\n"

# curl -i \
#      -H "Content-Type: application/json" \
#      -X DELETE \
#      -d '{ }' \
#      http://localhost:4567/users/sousou/lists/1/products/3
