CONTAINERS := $(shell docker ps -aq)

show:
	docker ps
	docker volume ls
run: cleanall
	./setup.sh
clean:
	-docker stop $(CONTAINERS)
	-docker rm $(CONTAINERS)
	-docker network rm pgnetwork
	-rm -rf ./_postgres
cleanall: clean
	-docker volume prune -f
