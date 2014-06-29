# -*- coding: utf-8 -* 
'''
Created on 2013-10-28

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
def getCollectionCount(collector):
    conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
    x = conn.cursor()
   
    try:
        count = x.execute("""select count(*) from BuTuBuKuai_collection where collector=%s """,(collector))
        count = x.fetchone()[0]
        conn.commit()
        x.close()
        conn.close()
        
    except:
        conn.rollback()
        x.close()
        conn.close()
    return count 

def addCollection(collectorParameter,collectiontypeParameter,pidParameter,pmd5codeParameter,contentParameter,imageurlParameter):
    conn = MySQLdb.connect (host = conhost, user =conuser, passwd =conpasswd, db = condb,charset = 'utf8')
    cursor= conn.cursor()
   
    try:
        count = cursor.execute("""select count(*) from BuTuBuKuai_collection where collector=%s and collectiontype=%s and pid=%s;""",(collectorParameter,collectiontypeParameter,pidParameter))
        count = cursor.fetchone()[0]
        if count==0:
            cursor.execute("""INSERT INTO BuTuBuKuai_collection(collector,collectiontype,pid,pmd5code,content,imageurl) VALUES (%s,%s,%s,%s,%s,%s)""",(collectorParameter,collectiontypeParameter,pidParameter,pmd5codeParameter,contentParameter,imageurlParameter))
            conn.commit()
        cursor.close()
        conn.close()
        
    except:
        conn.rollback()
        cursor.close()
        conn.close()
     



if __name__ == '__main__':
#     count=getCollectionCount("李兴乐")
#     print count
    addCollection('李兴乐','nhimage',4,'dsfgs','adsgsfg啊是sghdfgh的如果是大富豪的方式sxds','sagras.jpg')
    
    
    
    
    