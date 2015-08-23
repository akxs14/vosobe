
# echo "Creating list...\n"

# curl -i \
#      -H "Content-Type: application/json" \
#      -X POST \
#      -d '{ "title": "demo_priv", "public": false }' \
#      http://localhost:4567/users/sousou/lists

echo ""
echo "Get sousou's lists..."
echo ""

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/sousou/lists

echo ""
echo "Get sousou's private lists... "
echo ""

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/sousou/lists/private

echo ""
echo "Get sousou's public lists..."
echo ""

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/sousou/lists/public
