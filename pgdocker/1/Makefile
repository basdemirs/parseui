CONTAINERS := $(shell docker ps -aq)

show:
	docker ps
	docker volume ls
run: clean
	chmod +x ./setup.sh
	bash -c ./setup.sh
clean: rmContainers
	-docker network rm pgnetwork
	-rm -rf ./_postgres
cleanall: clean
	-docker volume prune -f
rmContainers:
	-docker stop postgres pgadmin4
	-docker rm postgres pgadmin4
rmAllContainers:
	-docker stop $(CONTAINERS)
	-docker rm $(CONTAINERS)
