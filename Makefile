.PHONY: build

sparkVersion = 3.0.1
hadoopVersion = 3.3.1

build: lib/protometa-spark-${sparkVersion}-hadoop-${hadoopVersion}.image-digest

# build hadoop into spark-without-hadoop image
lib/protometa-spark-${sparkVersion}-hadoop-${hadoopVersion}.image-digest: lib/protometa-spark-${sparkVersion}-without-hadoop.image-digest spark-hadoop.Dockerfile
	docker build . -f spark-hadoop.Dockerfile --build-arg sparkVersion=${sparkVersion} --build-arg hadoopVersion=${hadoopVersion} -t protometa/spark:${sparkVersion}-hadoop-${hadoopVersion}
	docker push protometa/spark:${sparkVersion}-hadoop-${hadoopVersion}
	docker image inspect protometa/spark:${sparkVersion}-hadoop-${hadoopVersion} | jq -r '.[0].RepoDigests[0]' > lib/protometa-spark-${sparkVersion}-hadoop-${hadoopVersion}.image-digest

# build k8s ready spark docker image
lib/protometa-spark-${sparkVersion}-without-hadoop.image-digest: lib/spark-${sparkVersion}-bin-without-hadoop
	cd lib/spark-${sparkVersion}-bin-without-hadoop/ && \
	  bin/docker-image-tool.sh -r docker.io/protometa -t ${sparkVersion}-without-hadoop build && \
	  bin/docker-image-tool.sh -r docker.io/protometa -t ${sparkVersion}-without-hadoop push
	docker image inspect protometa/spark:${sparkVersion}-without-hadoop | jq -r '.[0].RepoDigests[0]' > lib/protometa-spark-${sparkVersion}-without-hadoop.image-digest

# download and extract spark
lib/spark-${sparkVersion}-bin-without-hadoop:
	mkdir -p lib
	wget -P lib https://archive.apache.org/dist/spark/spark-${sparkVersion}/spark-${sparkVersion}-bin-without-hadoop.tgz
	tar -x -C lib -f lib/spark-${sparkVersion}-bin-without-hadoop.tgz
	rm lib/spark-${sparkVersion}-bin-without-hadoop.tgz
