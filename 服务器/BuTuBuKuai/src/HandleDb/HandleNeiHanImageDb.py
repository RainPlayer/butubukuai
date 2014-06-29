# -*- coding: utf-8 -*  
'''
Created on 2013-10-22

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
insert into myapp_document
'''

def insertUserNameToDocument(username):
    try:  
        conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
        cursor = conn.cursor()
        cursor.execute("""UPDATE myapp_document SET username=%@ where id=11 """,(username))
        conn.commit()
        
    except:
        conn.rollback() 
    cursor.close()
    conn.close()
    
'''
修改赞的数量
'''        
def addPraiseNumber(idParam):
    try:  
        conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
        cursor = conn.cursor()
        cursor.execute("""UPDATE myapp_document SET praisenumber=praisenumber+1 where id=%s """,(idParam))
        conn.commit()
        
    except:
        conn.rollback() 
    cursor.close()
    conn.close()



'''
修改贬的数量
'''
def addNaiHanImageBadNumber(idParam):
    try:  
        conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
        cursor = conn.cursor()
        cursor.execute("""UPDATE myapp_document SET badnumber=badnumber+1 where id=%s """,(idParam))
        conn.commit()
        
    except:
        conn.rollback() 
    cursor.close()
    conn.close()

        
#insertNeiHanArticle('lixingle','测试插入','asfgrts')      
#addPraiseNumber(56)        
addNaiHanImageBadNumber(63)           
                
        
        
        
        