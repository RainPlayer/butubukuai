# -*- coding: utf-8 -*  
'''
Created on 2013-9-19

@author: lixingle
'''

import MySQLdb

from BuTuBuKuai import settings
conname=settings.conname
conuser = settings.conuser
conhost = settings.conhost
conpasswd = settings.conpasswd
condb = settings.condb
conport =settings.conport

'''
插入成功返回1,失败返回0
'''
def insertUser(name,password,grade):
    
    conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
    x = conn.cursor()
    if len(name)<2:
        return -1
    
    try:
        count = x.execute("""select count(*) from BuTuBuKuai_user where name=%s """,(name))
        count = x.fetchone()[0]
        
        if count==0 :
            x.execute("""INSERT INTO BuTuBuKuai_user(name,password,grade) VALUES (%s,%s,%s)""",(name,password,grade))
            result=1
        else:
            result=0
        conn.commit()
        x.close()
        conn.close()
    except:
        conn.rollback()
    return result    
'''
更改用户信息
'''
def updateUser(password,name,myid):
     
    conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
    x = conn.cursor()
    if  len(name)<2 or len(password)<2 :
        return -1
        
    try:
        count = x.execute("""select count(*) from BuTuBuKuai_user where name=%s """,(name))
        count = x.fetchone()[0]
        if count==0:
            x.execute ("""
           UPDATE BuTuBuKuai_user
           SET name=%s, password=%s 
           WHERE id=%s
           """, (name,password,myid))
            result=1
        else :
            result=0
        conn.commit()
        x.close()
        conn.close()
    except:
        
        conn.rollback()
    return result


'''
通过Id删除用户
'''
def deleteUserByName(name):
     
    conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
    x = conn.cursor()
    
    try:
        
        x.execute ("""
       delete from BuTuBuKuai_user where name = %s;
       """, (name))
        
        conn.commit()
        x.close()
        conn.close()
    except:
        
        conn.rollback()
    return 1



# if __name__ == '__main__':
# #     result=insertUser('haha','123','cainiao')
# 
#     result=updateUser('123','不吐不快',2)
#     print result
#     #deleteUserByName('星夜')


