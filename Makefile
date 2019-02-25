
# download, verify, and extract spark 2.4.0
lib/spark-2.4.0-bin-without-hadoop:
	mkdir -p lib
	wget -P lib https://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-without-hadoop.tgz \
	  https://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-without-hadoop.tgz.asc \
	  https://www.apache.org/dist/spark/KEYS
	# gpg --import lib/KEYS
	# gpg --verify lib/spark-2.4.0-bin-without-hadoop.tgz.asc lib/spark-2.4.0-bin-without-hadoop.tgz 
	tar -x -C lib -f lib/spark-2.4.0-bin-without-hadoop.tgz
	rm lib/spark-2.4.0-bin-without-hadoop.tgz lib/KEYS lib/spark-2.4.0-bin-without-hadoop.tgz.asc

# build k8s ready spark 2.4.0 docker image
lib/protometa-spark-2.4.0-without-hadoop.image-digest: lib/spark-2.4.0-bin-without-hadoop
	cd lib/spark-2.4.0-bin-without-hadoop/ && \
	  bin/docker-image-tool.sh -r docker.io/protometa -t 2.4.0-without-hadoop build && \
	  bin/docker-image-tool.sh -r docker.io/protometa -t 2.4.0-without-hadoop push
	docker image inspect protometa/spark:2.4.0-without-hadoop | jq -r '.[0].RepoDigests[0]' > lib/protometa-spark-2.4.0-without-hadoop.image-digest

# download, verify, and extract hadoop 3.2.0
lib/hadoop-3.2.0:
	mkdir -p lib
	wget -P lib http://mirrors.gigenet.com/apache/hadoop/common/hadoop-3.2.0/hadoop-3.2.0.tar.gz || \
	wget -P lib http://mirrors.ocf.berkeley.edu/apache/hadoop/common/hadoop-3.2.0/hadoop-3.2.0.tar.gz
	wget -P lib https://dist.apache.org/repos/dist/release/hadoop/common/hadoop-3.2.0/hadoop-3.2.0.tar.gz.asc \
	  https://dist.apache.org/repos/dist/release/hadoop/common/KEYS
	# gpg --import lib/KEYS
	# gpg --verify lib/hadoop-3.2.0.tar.gz.asc lib/hadoop-3.2.0.tar.gz
	tar -x -C lib -f lib/hadoop-3.2.0.tar.gz
	rm lib/hadoop-3.2.0.tar.gz lib/KEYS lib/hadoop-3.2.0.tar.gz.asc

# build hadoop 3.2.0 into spark:2.4.0-without-hadoop
lib/protometa-spark-2.4.0-hadoop-3.2.0.image-digest: lib/protometa-spark-2.4.0-without-hadoop.image-digest spark-2.4.0-hadoop-3.2.0.Dockerfile
	docker build . -f spark-2.4.0-hadoop-3.2.0.Dockerfile -t protometa/spark:2.4.0-hadoop-3.2.0
	docker push protometa/spark:2.4.0-hadoop-3.2.0
	docker image inspect protometa/spark:2.4.0-hadoop-3.2.0 | jq -r '.[0].RepoDigests[0]' > lib/protometa-spark-2.4.0-hadoop-3.2.0.image-digest
