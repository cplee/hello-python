SOURCE_COMMIT ?= $(shell git rev-parse HEAD)
NAME ?= $(notdir $(CURDIR))
PORT ?= 5000

build:
	@echo $(SOURCE_COMMIT)
	@docker build -t $(NAME):latest --build-arg SOURCE_COMMIT=$(SOURCE_COMMIT) .
	
test:
	-@docker rm -f $(NAME)
	@docker run -d --name $(NAME) $(NAME):latest
	@while docker inspect -f "{{.State.Health.Status}}" $(NAME) | grep starting; do sleep 1; done
	@docker inspect -f "{{.State.Health.Status}}" $(NAME) | grep "^healthy$$"
	-@docker rm -f $(NAME)
	
run: 
	-@docker rm -f $(NAME) > /dev/null 2>&1
	@docker run -p $(PORT):$(PORT) -d --name $(NAME) $(NAME):latest
	@sleep 1
	@curl http://localhost:$(PORT) 
	@docker logs -f $(NAME)
	