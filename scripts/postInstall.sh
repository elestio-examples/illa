#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 60s;

target=$(docker-compose port illa-builder 80)

docker exec -t ${CONTAINER_NAME} sh -c "psql -U postgres postgres <<EOF
\c illa_supervisor
CREATE EXTENSION pgcrypto;
UPDATE users SET password_digest=crypt('$ADMIN_PASSWORD', gen_salt('bf', 8)), email='$ADMIN_EMAIL' WHERE nickname = 'root';
EOF";
