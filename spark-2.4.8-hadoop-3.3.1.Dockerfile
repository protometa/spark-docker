FROM protometa/spark:2.4.8-without-hadoop

RUN apt-get update && apt install -y wget && rm -rf /var/cache/apt/*

RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-3.3.1/hadoop-3.3.1.tar.gz && \
  tar -x -C /opt -f hadoop-3.3.1.tar.gz && \
  ln -s /opt/hadoop-3.3.1 /opt/hadoop && \
  rm hadoop-3.3.1.tar.gz

# these are both needed at different stages from some reason
ENV SPARK_DIST_CLASSPATH=/opt/hadoop-3.3.1/etc/hadoop:/opt/hadoop-3.3.1/share/hadoop/common/lib/*:/opt/hadoop-3.3.1/share/hadoop/common/*:/opt/hadoop-3.3.1/share/hadoop/hdfs:/opt/hadoop-3.3.1/share/hadoop/hdfs/lib/*:/opt/hadoop-3.3.1/share/hadoop/hdfs/*:/opt/hadoop-3.3.1/share/hadoop/mapreduce/lib/*:/opt/hadoop-3.3.1/share/hadoop/mapreduce/*:/opt/hadoop-3.3.1/share/hadoop/yarn:/opt/hadoop-3.3.1/share/hadoop/yarn/lib/*:/opt/hadoop-3.3.1/share/hadoop/yarn/*
ENV SPARK_EXTRA_CLASSPATH=$SPARK_DIST_CLASSPATH
