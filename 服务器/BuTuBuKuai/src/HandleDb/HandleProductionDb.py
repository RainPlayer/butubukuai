# -*- coding: utf-8 -*  
'''
Created on 2013-10-30

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

'''
def getProductionCount(idParam,nameParam):
    conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
    x = conn.cursor()
   
    try:
        nhArticleCount = x.execute("""select count(*) from BuTuBuKuai_neihanarticle where userid=%s """,(idParam))
        nhArticleCount = x.fetchone()[0]
        
        poetryCount = x.execute("""select count(*) from BuTuBuKuai_poetry where userid=%s """,(idParam))
        poetryCount = x.fetchone()[0]
        
        nhImageCount = x.execute("""select count(*) from myapp_document where username=%s """,(nameParam))
        nhImageCount = x.fetchone()[0]
        
        count=nhArticleCount+poetryCount+nhImageCount
        conn.commit()
        x.close()
        conn.close()
        
    except:
        conn.rollback()
        x.close()
        conn.close()
    return count


def getProductions(userIdParam,userNameParam):
    conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
    cursor = conn.cursor()
    
    try:
        cursor.execute("""select * from BuTuBuKuai_neihanarticle where userid=%s """,(userIdParam))
        rows = cursor.fetchall()
        print rows
#         for row in rows:
#             print row
        
        cursor.execute("""select * from BuTuBuKuai_poetry where userid=%s """,(userIdParam))
        rows = cursor.fetchall()
        print rows
        
        
        cursor.execute("""select * from myapp_document where username=%s """,(userNameParam))
        rows = cursor.fetchall()
        print rows



        conn.commit()
        cursor.close()
        conn.close()
        
    except:
        conn.rollback()
        cursor.close()
        conn.close()
#getProductions(3,'李兴乐')













 