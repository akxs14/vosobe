
printf "\n\n Sousou follows akxs14... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X POST \
     -d '{}' \
     http://localhost:4567/users/sousou/users/following/akxs14


printf "\n\n Get the users sousou is following... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/sousou/users/following


printf "\n\n Get the users sousou has unfollowed... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/sousou/users/unfollowed



printf "\n\n Get the followers of akxs14... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/akxs14/users/followers



printf "\n\n Sousou unfollow akxs14... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X DELETE \
     -d '{ }' \
     http://localhost:4567/users/sousou/users/following/akxs14


printf "\n\n Get the users sousou is following... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/sousou/users/following


printf "\n\n Get the unfollowers of akxs14... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/akxs14/users/unfollowers


printf "\n\n Get the users sousou has unfollowed... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/sousou/users/unfollowed


printf "\n\n Get the followers of akxs14... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/akxs14/users/followers


printf "\n\n Get the unfollowers of akxs14... \n\n"

curl -i \
     -H "Content-Type: application/json" \
     -X GET \
     -d '{}' \
     http://localhost:4567/users/akxs14/users/unfollowers
