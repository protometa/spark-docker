FROM protometa/spark:2.4.0-without-hadoop

COPY lib/hadoop-3.2.0 /opt/hadoop
ENV SPARK_DIST_CLASSPATH=/opt/hadoop/etc/hadoop:/opt/hadoop/share/hadoop/common/lib/*:/opt/hadoop/share/hadoop/common/*:/opt/hadoop/share/hadoop/hdfs:/opt/hadoop/share/hadoop/hdfs/lib/*:/opt/hadoop/share/hadoop/hdfs/*:/opt/hadoop/share/hadoop/mapreduce/lib/*:/opt/hadoop/share/hadoop/mapreduce/*:/opt/hadoop/share/hadoop/yarn:/opt/hadoop/share/hadoop/yarn/lib/*:/opt/hadoop/share/hadoop/yarn/*

RUN wget -P /opt/hadoop/share/hadoop/common/ http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.2.0/hadoop-aws-3.2.0.jar
RUN wget -P /opt/spark/jars http://central.maven.org/maven2/com/github/traviscrawford/spark-dynamodb/0.0.13/spark-dynamodb-0.0.13.jar
