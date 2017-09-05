---
layout: post
title: multiprocess pool
date: 2016-11-09
categories: python
tags: programming
---
#### <strong>Abstract:</strong>
This program is to test python process pool.<br>

if no pool.join and result, you may not see all the output from subprocess<br>

Be careful that the input functions for multiprocess pool can't be class method, no matter it's static or not.<br>
Lambda expression that represent a function is also invalid.<br>

The expected input funtions should be normal funtion(outside of class).<br>
It's ok to call other process in the normal funtion.

#### <strong>Content:</strong>

    import multiprocessing
    import time
    import subprocess

    class JobSubmit(object):
        def func(msg):
            for i in xrange(3):
                print msg
                time.sleep(0.5)
            return "done " + msg

    def func(msg):
        for i in xrange(3):
            print msg
            time.sleep(0.5)
        return "done " + msg

    def func1(msg):
        for i in xrange(3):
            cmd='echo '+msg
            subprocess.call(cmd, shell=True)
            time.sleep(3)
        return "done " + msg

    if __name__ == "__main__":
        pool = multiprocessing.Pool(processes=6)
        result = []

        if 0: #this run well
            for i in xrange(10):
                msg = "hello %d" %(i)
                result.append(pool.apply_async(func, (msg, )))
            print "in the middle"
            time.sleep(3)
            for i in xrange(10,15):
                msg = "hello %d" %(i)
                result.append(pool.apply_async(func, (msg, )))
            pool.close()
            pool.join()
            for res in result:
                print res.get()
            print "Sub-process(es) done."

        if 0: #this fail as pool can handle method in class
            js=JobSubmit()
            for i in xrange(10):
                msg = "hello %d" %(i)
                result.append(pool.apply_async(js.func, (msg, )))
            print "in the middle"
            time.sleep(3)
            for i in xrange(10,15):
                msg = "hello %d" %(i)
                result.append(pool.apply_async(js.func, (msg, )))
            pool.close()
            pool.join()
            for res in result:
                print res.get()
            print "Sub-process(es) done."

        #if 0: # run well to call other process
        for i in xrange(5):
            msg = "hello %d" %(i)
            result.append(pool.apply_async(func1, (msg, )))
        print "in the middle"
        time.sleep(0.1)
        for i in xrange(10,15):
            msg = "hello %d" %(i)
            result.append(pool.apply_async(func1, (msg, )))
        pool.close()
        pool.join()
        for res in result:
            print res.get()
        print "Sub-process(es) done."

        if 0:  # call lambda, faild, can't call lambda
            for i in xrange(10):
                msg = "echo %d" %(i)
                result.append(pool.apply_async(lambda x: subprocess.Popen(x, shell=True), (msg, )))
            pool.close()
            pool.join()
            for res in result:
                print res.get()
            print "Sub-process(es) done."

#### <strong>History:</strong>
* <em>2016-11-09</em>:create the page<br>

