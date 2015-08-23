
printf "\n\n Sousou follows akxs14/1 list... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X POST \
     -d '{}' \
     http://localhost:4567/users/sousou/lists/following/akxs14/1


printf "\n\n Get the lists sousou is following... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/sousou/lists/following


printf "\n\n Get the lists sousou has unfollowed... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/sousou/lists/unfollowed



printf "\n\n Get the followers of akxs14 list 1... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/akxs14/lists/1/followers



printf "\n\n Unfollow list... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X DELETE \
     -d '{ }' \
     http://localhost:4567/users/sousou/lists/following/akxs14/1


printf "\n\n Get the lists sousou is following... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/sousou/lists/following


printf "\n\n Get the lists sousou has unfollowed... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/sousou/lists/unfollowed


printf "\n\n Get the followers of akxs14 list 1... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/akxs14/lists/1/followers
