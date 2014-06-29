# -*- coding: utf-8 -*  
'''
Created on 2013-9-26

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

'''
发表文章
'''


def insertNeiHanArticle(userid,article,md5code):
    
    
   
    
    try:
        conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
        cursor = conn.cursor()
        ntime=time.strftime('%m-%d %H:%M',time.localtime(time.time()))
        
        cursor.execute("""INSERT INTO BuTuBuKuai_neihanarticle(userid,date,article,md5code) VALUES (%s,%s,%s,%s)""",(userid,ntime,article,md5code))

        conn.commit()
        cursor.close()
        conn.close()
    except:
        conn.rollback() 
        
        
        
'''
修改赞的数量
'''        
def addPraiseNumber(md5code):
    try:  
        conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
        cursor = conn.cursor()
        cursor.execute("""UPDATE BuTuBuKuai_neihanarticle SET praisenumber=praisenumber+1 where md5code=%s """,(md5code))
        conn.commit()
        
    except:
        conn.rollback() 
    cursor.close()
    conn.close()



'''
修改贬的数量
'''
def addNaiHanArticleBadNumber(md5code):
    try:  
        conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
        cursor = conn.cursor()
        cursor.execute("""UPDATE BuTuBuKuai_neihanarticle SET badnumber=badnumber+1 where md5code=%s """,(md5code))
        conn.commit()
        
    except:
        conn.rollback() 
    cursor.close()
    conn.close()

        
#insertNeiHanArticle('lixingle','测试插入','asfgrts')      
# addPraiseNumber('a340dd2dda7b70ac76d3cc3b43eda6f2')        
# addNaiHanArticleBadNumber('a340dd2dda7b70ac76d3cc3b43eda6f2')           
        