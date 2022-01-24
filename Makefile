.PHONY: spark-2.3.2-hadoop-2.7 spark-2.4.8-hadoop-3.2.0

# download and extract spark 2.3.2
lib/spark-2.3.2-bin-hadoop2.7:
	mkdir -p lib
	wget -P lib https://www.apache.org/dist/spark/spark-2.3.2/spark-2.3.2-bin-hadoop2.7.tgz
	tar -x -C lib -f lib/spark-2.3.2-bin-without-hadoop.tgz
	rm lib/spark-2.3.2-bin-hadoop2.7.tgz

# build k8s ready spark 2.3.2 docker image
lib/protometa-spark-2.3.2-hadoop-2.7.image-digest: lib/spark-2.3.2-bin-without-hadoop
	cd lib/lib/spark-2.3.2-bin-hadoop2.7/ && \
	  bin/docker-image-tool.sh -r docker.io/protometa -t 2.3.2-hadoop-2.7 build && \
	  bin/docker-image-tool.sh -r docker.io/protometa -t 2.3.2-hadoop-2.7 push
	docker image inspect protometa/spark:2.3.2-hadoop-2.7 | jq -r '.[0].RepoDigests[0]' > lib/protometa-spark-2.3.2-hadoop-2.7.image-digest

# download and extract spark 2.4.8
lib/spark-2.4.8-bin-without-hadoop-scala-2.12:
	mkdir -p lib
	wget -P lib https://downloads.apache.org/spark/spark-2.4.8/spark-2.4.8-bin-without-hadoop-scala-2.12.tgz
	tar -x -C lib -f lib/spark-2.4.8-bin-without-hadoop-scala-2.12.tgz
	rm lib/spark-2.4.8-bin-without-hadoop-scala-2.12.tgz

# build k8s ready spark 2.4.8 docker image
lib/protometa-spark-2.4.8-without-hadoop.image-digest: lib/spark-2.4.8-bin-without-hadoop-scala-2.12
	cd lib/spark-2.4.8-bin-without-hadoop-scala-2.12/ && \
	  bin/docker-image-tool.sh -r docker.io/protometa -t 2.4.8-without-hadoop build && \
	  bin/docker-image-tool.sh -r docker.io/protometa -t 2.4.8-without-hadoop push
	docker image inspect protometa/spark:2.4.8-without-hadoop | jq -r '.[0].RepoDigests[0]' > lib/protometa-spark-2.4.8-without-hadoop.image-digest

# build hadoop 3.2.0 into spark:2.4.8-without-hadoop
lib/protometa-spark-2.4.8-hadoop-3.2.0.image-digest: lib/protometa-spark-2.4.8-without-hadoop.image-digest spark-2.4.8-hadoop-3.2.0.Dockerfile
	docker build . -f spark-2.4.8-hadoop-3.2.0.Dockerfile -t protometa/spark:2.4.8-hadoop-3.2.0
	docker push protometa/spark:2.4.8-hadoop-3.2.0
	docker image inspect protometa/spark:2.4.8-hadoop-3.2.0 | jq -r '.[0].RepoDigests[0]' > lib/protometa-spark-2.4.8-hadoop-3.2.0.image-digest

spark-2.3.2-hadoop-2.7: lib/protometa-spark-2.3.2-hadoop-2.7.image-digest
spark-2.4.8-hadoop-3.2.0: lib/protometa-spark-2.4.8-hadoop-3.2.0.image-digest
