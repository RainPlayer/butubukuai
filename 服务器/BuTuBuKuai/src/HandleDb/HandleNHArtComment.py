# -*- coding: utf-8 -*  
'''
Created on 2013-9-27

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

def insertNHArtComment(Pmd5codeParam,observerParam,discussParam):
  
    try:
        conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
        cursor = conn.cursor()
        #获得楼层数
        count = cursor.execute("""select count(*) from BuTuBuKuai_nhartcomment where Pmd5code=%s """,(Pmd5codeParam))
        count = cursor.fetchone()[0]
        ntime=time.strftime('%m-%d %H:%M',time.localtime(time.time()))
        
        cursor.execute("""INSERT INTO BuTuBuKuai_nhartcomment(floor, Pmd5code,discuss,observer,date) VALUES (%s,%s,%s,%s,%s)""",(count+1,Pmd5codeParam,discussParam,observerParam,ntime))

        conn.commit()
        cursor.close()
        conn.close()
    except:
        conn.rollback() 

'''
修改赞的数量
'''        
def addNHArtComPraiseNumber(id):
    try:  
        conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
        cursor = conn.cursor()
        cursor.execute("""UPDATE BuTuBuKuai_nhartcomment SET praisenumber=praisenumber+1 where id=%s """,(id))
        conn.commit()
        
    except:
        conn.rollback() 
    cursor.close()
    conn.close()



        
#insertNHArtComment('aaa','刘德华','你好这是我得评论')        
addNHArtComPraiseNumber(2)        
        
        
        
        