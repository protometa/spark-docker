ARG sparkVersion
FROM protometa/spark:${sparkVersion}-without-hadoop

ARG hadoopVersion

USER root

RUN apt-get update && apt install -y wget && rm -rf /var/cache/apt/*

RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-${hadoopVersion}/hadoop-${hadoopVersion}.tar.gz && \
  tar -x -C /opt -f hadoop-${hadoopVersion}.tar.gz && \
  ln -s /opt/hadoop-${hadoopVersion} /opt/hadoop && \
  rm hadoop-${hadoopVersion}.tar.gz

# return to spark user
USER 185

# from `hadoop classpath`
ENV SPARK_DIST_CLASSPATH=/opt/hadoop-${hadoopVersion}/etc/hadoop:/opt/hadoop-${hadoopVersion}/share/hadoop/common/lib/*:/opt/hadoop-${hadoopVersion}/share/hadoop/common/*:/opt/hadoop-${hadoopVersion}/share/hadoop/hdfs:/opt/hadoop-${hadoopVersion}/share/hadoop/hdfs/lib/*:/opt/hadoop-${hadoopVersion}/share/hadoop/hdfs/*:/opt/hadoop-${hadoopVersion}/share/hadoop/mapreduce/*:/opt/hadoop-${hadoopVersion}/share/hadoop/yarn:/opt/hadoop-${hadoopVersion}/share/hadoop/yarn/lib/*:/opt/hadoop-${hadoopVersion}/share/hadoop/yarn/*
# extra tools path
ENV SPARK_DIST_CLASSPATH=$SPARK_DIST_CLASSPATH:/opt/hadoop-${hadoopVersion}/share/hadoop/tools/lib/*
# these are both needed at different stages from some reason
ENV SPARK_EXTRA_CLASSPATH=$SPARK_DIST_CLASSPATH
