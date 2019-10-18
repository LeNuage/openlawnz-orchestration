ECHO OFF
SET DB_MOUNT_VOLUME=data

ECHO "Creating mount volume directory"
md %DB_MOUNT_VOLUME%

REM Docker machines may have new IP addresses. You may need to re-run the `docker-machine env` command

ECHO "Running docker image"
docker pull postgres
docker run --name openlawnz-postgres -p5432:5432 -v %DB_MOUNT_VOLUME%:/var/lib/postgresql/data -d postgres

ECHO "Downloading latest OpenLaw NZ database"
curl -o openlawnzdb.sql https:<URL provided by volunteering with OpenLaw NZ>

ECHO "Copying database into docker"
docker cp openlawnzdb.sql openlawnz-postgres:/tmp

ECHO "Restoring database into postgres instance" 
docker exec -it openlawnz-postgres psql -U postgres -c "create database openlawnz_db"
docker exec -it openlawnz-postgres pg_restore --no-owner -U postgres -d openlawnz_db /tmp/openlawnzdb.sql  -v

docker exec openlawnz-postgres rm /tmp/openlawnzdb.sql
rm openlawnzdb.sql
