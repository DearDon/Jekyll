---
layout: post
title: python实现单例模式
date: 2016-09-15
categories: python 
tags: python singleton 
---
#### <strong>History:</strong>
* <em>20160911</em>:将实现单例的代码和注释记录下来<br>
* <em>20160921</em>:更新跨模块单例失败的问题<br>

#### <strong>Background:</strong>
Singleton是创建模式中很典型的一类，在Java中是通过将构造函数private来实现的。在python中，没有private，我们通过share一个类或子类的所有成员变量来实现单例。<br>
注意，虽然所有对象都共享相同的成员，但和Java中的单例还是有差别。java中是真的只建了一个对象，但python中实际有多个对象(id不同), 但成员相同。

#### <strong>Content:</strong>
话不多说，直接上代码，注释写得很清楚。只要将你自己的类继承下面的Singleton类，即实现了将你的类转换成了单例模式。

    class Singleton:
        '''parent singleton class, make your class to inherit it to transfer yours to singleton''' 
        __shared_state = {} #create share dictionary, use to store member of class later
        self_variable = 0

        def __init__(self):
            self.__dict__ = self.__shared_state  #use shared dic to implement singleton
            self.state = 'Init'
            self.array = [1,2]

        def __str__(self): #you can delete it, just for transfer obj to str 
            return self.state

    class SubSingleton(Singleton):
        pass

    def main():
        rm1 = Singleton()
        rm2 = Singleton()
        rm1.self_variable = 1 #reassign shared variable will be visible for all singleton object
        rm2.state = 'Running'
        rm3 = Singleton() #even new object, it will get latest value if not reassign
        rm4 = SubSingleton() #for sub class, singleton function well. Share with parent
        rm4.array = [2,4]
        print('rm1: {0}'.format(rm1))
        print('rm1: {0}'.format(rm1.self_variable))
        print('rm1: {0}'.format(rm1.array))
        print('rm2: {0}'.format(rm2))
        print('rm2: {0}'.format(rm2.self_variable))
        print('rm2: {0}'.format(rm2.array))
        print('rm3: {0}'.format(rm3))
        print('rm3: {0}'.format(rm3.self_variable))
        print('rm3: {0}'.format(rm3.array))
        print('rm4: {0}'.format(rm4))
        print('rm4: {0}'.format(rm4.self_variable))
        print('rm4: {0}'.format(rm4.array))
        print('rm1 id: {0}'.format(id(rm1))) #id is different, means there are many obj sharing same members
        print('rm2 id: {0}'.format(id(rm2)))
        print('rm3 id: {0}'.format(id(rm3)))
        print('rm4 id: {0}'.format(id(rm4)))

    if __name__ == '__main__':
        main()

运行上面代码，得到如下output，实现了共享方式的"单例"。

    rm1: Init
    rm1: 1
    rm1: [2, 4]
    rm2: Init
    rm2: 1
    rm2: [2, 4]
    rm3: Init
    rm3: 1
    rm3: [2, 4]
    rm4: Init
    rm4: 1
    rm4: [2, 4]
    rm1 id: 3078847052
    rm2 id: 3078848332
    rm3 id: 3078848364
    rm4 id: 3078848396

最新实践发现，这种多个对象模拟单例对象的另一个问题————不能跨模块。如果在其它文件中导入该单例模块，再新建单例类的对象，会发现各模块中的单例对象不能实现共享了。
