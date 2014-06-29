# -*- coding: utf-8 -*  
'''
Created on 2013-10-15

@author: lixingle
'''
'''
发表内涵段子的评论
'''
import MySQLdb
import time
from BuTuBuKuai import settings
conname=settings.conname
conuser = settings.conuser
conhost = settings.conhost
conpasswd = settings.conpasswd
condb = settings.condb
conport =settings.conport

def insertPoetryComment(Pmd5codeParam,observerParam,discussParam):
  
    try:
        conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
        cursor = conn.cursor()
        #获得楼层数
        count = cursor.execute("""select count(*) from BuTuBuKuai_poetrycomment where Pmd5code=%s """,(Pmd5codeParam))
        count = cursor.fetchone()[0]
        print count
        
        ntime=time.strftime('%m-%d %H:%M',time.localtime(time.time()))
        
        cursor.execute("""INSERT INTO BuTuBuKuai_Poetrycomment(floor, Pmd5code,discuss,observer,date) VALUES (%s,%s,%s,%s,%s)""",(count+1,Pmd5codeParam,discussParam,observerParam,ntime))

        conn.commit()
        cursor.close()
        conn.close()
    except:
        conn.rollback() 

'''
修改赞的数量
'''        
def addPoetryComPraiseNumber(id):
    try:  
        conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
        cursor = conn.cursor()
        cursor.execute("""UPDATE BuTuBuKuai_Poetrycomment SET praisenumber=praisenumber+1 where id=%s """,(id))
        conn.commit()
        
    except:
        conn.rollback() 
    cursor.close()
    conn.close()



        
# insertPoetryComment('5d1543565e95d0fbc49386d4873b16d3','德华','你好这是我得评论')        
# addPoetryComPraiseNumber(2)        
        
        
        
      