FROM protometa/spark:2.4.0-without-hadoop

RUN wget http://mirrors.ocf.berkeley.edu/apache/hadoop/common/hadoop-3.2.0/hadoop-3.2.0.tar.gz || \
  wget http://mirrors.gigenet.com/apache/hadoop/common/hadoop-3.2.0/hadoop-3.2.0.tar.gz && \
  echo "226b6cbdf769467250054b3abdf26df9f05fde44bbb82fe5d12d6993ea848f64  hadoop-3.2.0.tar.gz" | sha256sum -c && \
  tar -x -C /opt -f hadoop-3.2.0.tar.gz && \
  ln -s /opt/hadoop-3.2.0 /opt/hadoop && \
  rm hadoop-3.2.0.tar.gz

# these are both needed at different stages from some reason
ENV SPARK_DIST_CLASSPATH=/opt/hadoop-3.2.0/etc/hadoop:/opt/hadoop-3.2.0/share/hadoop/common/lib/*:/opt/hadoop-3.2.0/share/hadoop/common/*:/opt/hadoop-3.2.0/share/hadoop/hdfs:/opt/hadoop-3.2.0/share/hadoop/hdfs/lib/*:/opt/hadoop-3.2.0/share/hadoop/hdfs/*:/opt/hadoop-3.2.0/share/hadoop/mapreduce/lib/*:/opt/hadoop-3.2.0/share/hadoop/mapreduce/*:/opt/hadoop-3.2.0/share/hadoop/yarn:/opt/hadoop-3.2.0/share/hadoop/yarn/lib/*:/opt/hadoop-3.2.0/share/hadoop/yarn/*
ENV SPARK_EXTRA_CLASSPATH=$SPARK_DIST_CLASSPATH
