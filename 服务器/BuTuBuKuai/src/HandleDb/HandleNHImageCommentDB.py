# -*- coding: utf-8 -*  
'''
Created on 2013-10-15

@author: lixingle
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

def insertNHImageComment(pid,observerParam,discussParam):
  
    try:
        conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
        cursor = conn.cursor()
        
        count = cursor.execute("""select count(*) from myapp_nhimagecomment where pid=%s """,(pid))
        count = cursor.fetchone()[0]
        ntime=time.strftime('%m-%d %H:%M',time.localtime(time.time()))
        
        cursor.execute("""INSERT INTO myapp_nhimagecomment(floor, pid,discuss,observer,date) VALUES (%s,%s,%s,%s,%s)""",(count+1,pid,discussParam,observerParam,ntime))

        conn.commit()
        cursor.close()
        conn.close()
    except:
        conn.rollback() 

'''

'''        
def addNHImageComPraiseNumber(id):
    try:  
        conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
        cursor = conn.cursor()
        cursor.execute("""UPDATE myapp_nhimagecomment SET praisenumber=praisenumber+1 where id=%s """,(id))
        conn.commit()
        
    except:
        conn.rollback() 
    cursor.close()
    conn.close()



#insertNHImageComment(63,'兴乐','好好好')        
addNHImageComPraiseNumber(2)        
        
        
        
      