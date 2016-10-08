---
layout: post
title: hadoop集群体验wordcount
date: 2016-09-22
categories: 折腾折腾
tags: Hadoop Wordcount
---
#### <strong>History:</strong>
* <em>20160922</em>:将内容记录下来<br>

#### <strong>Background:</strong>
之前介绍了用PC机借助虚拟机搭建分布式hadoop，这篇介绍用它体验hadoop的操作。

hadoop上最经典的入门案例就是wordcount了，经典到在hadoop2.5.2的安装包里默认装了wordcount的jar包。所以我们免除了写java文件的工作(有兴趣的话可以研究它的源码，从而模仿改写)，直接调用体验。

不过由于是在单机上虚拟出来的分布式环境，其实硬件资源跑三个虚拟机已经够呛了，所以hadoop的威力体现并不明显，wordcount跑了不少时间。<br>
但至少成功体验了跑一遍job，对hadoop感受更直接了。

#### <strong>Content:</strong>
<strong>一.为wordcount任务设定好输入输出</strong><br>
记得hadoop的所有操作都要在启动hadoop后呀，且正常情况下操作均只在master上(出异常时可能要去slave上检查，如本文后面删除各节点上有问题的dfs)。

    $ start-all.sh #启动hadoop

    $ hadoop fs -mkdir -p /input/wordcount  #在hdfs中创建输入输出目录
    $ hadoop fs -mkdir -p /output

    $ hadoop fs -ls / #查看hdfs中是否成功创建目录
    Found 2 items
    drwxr-xr-x   - hadoop supergroup          0 2016-09-22 20:13 /input
    drwxr-xr-x   - hadoop supergroup          0 2016-09-22 20:16 /output

当前路径下新建两个文本文件words1和words2，作为进入wordcount的输入，内容如下。

    $ cat words1
    hello master
    hello slave1
    hello slave2
    master slave

    $ cat words2
    hello Don
    Don master
    other slave

将本地的输入文件传到hdfs中，为wordcount程序使用。

    $ hadoop fs -put words1 words2 /input/wordcount/ #本地输入文件传到hdfs

    $ hadoop fs -ls /input/wordcount #查看是否上传成功
    Found 2 items
    -rw-r--r--   2 hadoop supergroup         52 2016-09-22 20:23 /input/wordcount/words1
    -rw-r--r--   2 hadoop supergroup         33 2016-09-22 20:23 /input/wordcount/words2

    $ hadoop fs -text /input/wordcount/words1 #查看上传后内容是否无误
    hello master
    hello slave1
    hello slave2
    master slave

<strong>二.执行wordcount任务</strong><br>
完成了前面的输入文件准备后，就可以提交任务了。

wordcount的java执行程序已经包含在hadoop安装路径下的share/hadoop/mapreduce/hadoop-mapreduce-examples-2.5.2.jar中，因此可直接执行。

    $ hadoop jar /home/hadoop/hadoop-2.5.2/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.5.2.jar wordcount /input/wordcount /output/wordcount
    16/09/22 21:15:19 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
    16/09/22 21:15:20 INFO client.RMProxy: Connecting to ResourceManager at master-desktop/10.133.24.235:8032
    16/09/22 21:15:22 INFO input.FileInputFormat: Total input paths to process : 2
    16/09/22 21:15:22 INFO mapreduce.JobSubmitter: number of splits:2
    16/09/22 21:15:23 INFO mapreduce.JobSubmitter: Submitting tokens for job: job_1474549833648_0001
    16/09/22 21:15:24 INFO impl.YarnClientImpl: Submitted application application_1474549833648_0001
    16/09/22 21:15:25 INFO mapreduce.Job: The url to track the job: http://master-desktop:8088/proxy/application_1474549833648_0001/
    16/09/22 21:15:25 INFO mapreduce.Job: Running job: job_1474549833648_0001
    16/09/22 21:16:12 INFO mapreduce.Job: Job job_1474549833648_0001 running in uber mode : false
    16/09/22 21:16:12 INFO mapreduce.Job:  map 0% reduce 0%
    16/09/22 21:25:31 INFO mapreduce.Job:  map 33% reduce 0%
    16/09/22 21:25:37 INFO mapreduce.Job:  map 50% reduce 0%
    16/09/22 21:25:39 INFO mapreduce.Job:  map 100% reduce 0%
    16/09/22 21:27:05 INFO mapreduce.Job:  map 100% reduce 100%
    16/09/22 21:27:13 INFO mapreduce.Job: Job job_1474549833648_0001 completed successfully
    16/09/22 21:27:13 INFO mapreduce.Job: Counters: 49
        File System Counters
            FILE: Number of bytes read=128
            FILE: Number of bytes written=291609
            FILE: Number of read operations=0
            FILE: Number of large read operations=0
            FILE: Number of write operations=0
            HDFS: Number of bytes read=313
            HDFS: Number of bytes written=57
            HDFS: Number of read operations=9
            HDFS: Number of large read operations=0
            HDFS: Number of write operations=2
        Job Counters 
            Launched map tasks=2
            Launched reduce tasks=1
            Data-local map tasks=2
            Total time spent by all maps in occupied slots (ms)=1180074
            Total time spent by all reduces in occupied slots (ms)=48176
            Total time spent by all map tasks (ms)=1180074
            Total time spent by all reduce tasks (ms)=48176
            Total vcore-seconds taken by all map tasks=1180074
            Total vcore-seconds taken by all reduce tasks=48176
            Total megabyte-seconds taken by all map tasks=1208395776
            Total megabyte-seconds taken by all reduce tasks=49332224
        Map-Reduce Framework
            Map input records=7
            Map output records=14
            Map output bytes=141
            Map output materialized bytes=134
            Input split bytes=228
            Combine input records=14
            Combine output records=10
            Reduce input groups=7
            Reduce shuffle bytes=134
            Reduce input records=10
            Reduce output records=7
            Spilled Records=20
            Shuffled Maps =2
            Failed Shuffles=0
            Merged Map outputs=2
            GC time elapsed (ms)=30842
            CPU time spent (ms)=6790
            Physical memory (bytes) snapshot=117768192
            Virtual memory (bytes) snapshot=1077792768
            Total committed heap usage (bytes)=237584384
        Shuffle Errors
            BAD_ID=0
            CONNECTION=0
            IO_ERROR=0
            WRONG_LENGTH=0
            WRONG_MAP=0
            WRONG_REDUCE=0
        File Input Format Counters 
            Bytes Read=85
        File Output Format Counters 
            Bytes Written=57

至此，任务执行完毕，从输出可以看到map确实花了不少时间(老pc机嘛)。

<strong>三.查看wordcount任务结果</strong><br>
可以直接查看存在hdfs中count的结果，先看结果文件。

    $ hadoop fs -ls /output/wordcount
    Found 2 items
    -rw-r--r--   2 hadoop supergroup          0 2016-09-22 21:27 /output/wordcount/_SUCCESS
    -rw-r--r--   2 hadoop supergroup         57 2016-09-22 21:27 /output/wordcount/part-r-00000

多了两个文件，第一个表示执行成功，第二个part-XXX文件才是输出结果。

    $ hadoop fs -text /output/wordcount/part-r-00000
    Don	2
    hello	4
    master	3
    other	1
    slave	2
    slave1	1
    slave2	1

可见，正确统计了各单词及数量。

#### <strong>Questions:</strong>
在提交任务时，输入下面命令后可能会abort掉。

    hadoop jar /home/hadoop/hadoop-2.5.2/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.5.2.jar wordcount /input/wordcount /output/wordcount

如果报错信息是关于datanode或IOException, 很可能是hdfs格式化的dfs文件在格式化的时候有问题(一般正常使用后不会有这问题，所以不用担心之后的数据丢失)。

尝试重新格式化，在格式化之前，需要将你NameNode上所配置的dfs.name.dir这一namenode用来存放NameNode 持久存储名字空间及事务日志的本地文件系统路径删除，同时将各DataNode上的dfs.data.dir的路径DataNode存放块数据的本地文件系统路径的目录也删除。

按前文配置的方式，其实就是删掉主目录下的dfs目录，删之前先用`stop-all.sh`关掉hadoop。<br>
之后在NameNode上执行命令`hadoop namenode -format`重新格式化HDFS。

之后用`start-all.sh`启动hadoop,它会默认把NameNode上的格式化HDFS也拷到其它DataNode上去。再从设置输入输出重头尝试。
