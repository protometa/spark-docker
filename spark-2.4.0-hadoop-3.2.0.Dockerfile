FROM protometa/spark:2.4.0-without-hadoop

COPY lib/hadoop-3.2.0 /opt/hadoop
RUN export SPARK_DIST_CLASSPATH=$(/opt/hadoop/bin/hadoop classpath)
